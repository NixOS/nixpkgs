/* Build configuration used to build glibc, Info files, and locale
   information.  */

{ stdenv, lib, fetchurl
, gd ? null, libpng ? null
, buildPlatform, hostPlatform
, buildPackages
}:

{ name
, withLinuxHeaders ? false
, profilingLibraries ? false
, installLocales ? false
, withGd ? false
, meta
, ...
} @ args:

let
  inherit (buildPackages) linuxHeaders;
  version = "2.25";
  sha256 = "067bd9bb3390e79aa45911537d13c3721f1d9d3769931a30c2681bfee66f23a0";
  cross = if buildPlatform != hostPlatform then hostPlatform else null;
in

assert withLinuxHeaders -> linuxHeaders != null;
assert withGd -> gd != null && libpng != null;

stdenv.mkDerivation ({
  inherit  installLocales;
  linuxHeaders = if withLinuxHeaders then linuxHeaders else null;

  # The host/target system.
  crossConfig = if cross != null then cross.config else null;

  inherit (stdenv) is64bit;

  enableParallelBuilding = true;

  patches =
    [ /* Have rpcgen(1) look for cpp(1) in $PATH.  */
      ./rpcgen-path.patch

      /* Allow NixOS and Nix to handle the locale-archive. */
      ./nix-locale-archive.patch

      /* Don't use /etc/ld.so.cache, for non-NixOS systems.  */
      ./dont-use-system-ld-so-cache.patch

      /* Don't use /etc/ld.so.preload, but /etc/ld-nix.so.preload.  */
      ./dont-use-system-ld-so-preload.patch

      /* Add blowfish password hashing support.  This is needed for
         compatibility with old NixOS installations (since NixOS used
         to default to blowfish). */
      ./glibc-crypt-blowfish.patch

      /* The command "getconf CS_PATH" returns the default search path
         "/bin:/usr/bin", which is inappropriate on NixOS machines. This
         patch extends the search path by "/run/current-system/sw/bin". */
      ./fix_path_attribute_in_getconf.patch

      /* Stack Clash */
      ./CVE-2017-1000366-rtld-LD_LIBRARY_PATH.patch
      ./CVE-2017-1000366-rtld-LD_PRELOAD.patch
      ./CVE-2017-1000366-rtld-LD_AUDIT.patch

      /* https://sourceware.org/bugzilla/show_bug.cgi?id=21666 */
      ./avoid-semver-on-common.patch
    ]
    ++ lib.optionals stdenv.isi686 [
      ./fix-i686-memchr.patch
      ./i686-fix-vectorized-strcspn.patch
    ]
    ++ lib.optional stdenv.isx86_64 ./fix-x64-abi.patch;

  postPatch =
    # Needed for glibc to build with the gnumake 3.82
    # http://comments.gmane.org/gmane.linux.lfs.support/31227
    ''
      sed -i 's/ot \$/ot:\n\ttouch $@\n$/' manual/Makefile
    ''
    # nscd needs libgcc, and we don't want it dynamically linked
    # because we don't want it to depend on bootstrap-tools libs.
    + ''
      echo "LDFLAGS-nscd += -static-libgcc" >> nscd/Makefile
    ''
    # Replace the date and time in nscd by a prefix of $out.
    # It is used as a protocol compatibility check.
    # Note: the size of the struct changes, but using only a part
    # would break hash-rewriting. When receiving stats it does check
    # that the struct sizes match and can't cause overflow or something.
    + ''
      cat ${./glibc-remove-datetime-from-nscd.patch} \
        | sed "s,@out@,$out," | patch -p1
    ''
    # CVE-2014-8121, see https://bugzilla.redhat.com/show_bug.cgi?id=1165192
    + ''
      substituteInPlace ./nss/nss_files/files-XXX.c \
        --replace 'status = internal_setent (stayopen);' \
                  'status = internal_setent (1);'
    '';

  configureFlags =
    [ "-C"
      "--enable-add-ons"
      "--enable-obsolete-rpc"
      "--sysconfdir=/etc"
      "--enable-stackguard-randomization"
      (if withLinuxHeaders
       then "--with-headers=${linuxHeaders}/include"
       else "--without-headers")
      (if profilingLibraries
       then "--enable-profile"
       else "--disable-profile")
    ] ++ lib.optionals (cross == null && withLinuxHeaders) [
      "--enable-kernel=2.6.32"
    ] ++ lib.optionals (cross != null) [
      (if cross.withTLS then "--with-tls" else "--without-tls")
      (if cross ? float && cross.float == "soft" then "--without-fp" else "--with-fp")
    ] ++ lib.optionals (cross != null
          && cross.platform ? kernelMajor
          && cross.platform.kernelMajor == "2.6") [
      "--enable-kernel=2.6.0"
      "--with-__thread"
    ] ++ lib.optionals (cross == null && stdenv.isArm) [
      "--host=arm-linux-gnueabi"
      "--build=arm-linux-gnueabi"

      # To avoid linking with -lgcc_s (dynamic link)
      # so the glibc does not depend on its compiler store path
      "libc_cv_as_needed=no"
    ] ++ lib.optional withGd "--with-gd";

  installFlags = [ "sysconfdir=$(out)/etc" ];

  outputs = [ "out" "bin" "dev" "static" ];

  nativeBuildInputs = lib.optional (cross != null) buildPackages.stdenv.cc;
  buildInputs = lib.optionals withGd [ gd libpng ];

  # Needed to install share/zoneinfo/zone.tab.  Set to impure /bin/sh to
  # prevent a retained dependency on the bootstrap tools in the stdenv-linux
  # bootstrap.
  BASH_SHELL = "/bin/sh";
}

// (removeAttrs args [ "withLinuxHeaders" "withGd" ]) //

{
  name = name + "-${version}" +
    lib.optionalString (cross != null) "-${cross.config}";

  src = fetchurl {
    url = "mirror://gnu/glibc/glibc-${version}.tar.xz";
    inherit sha256;
  };

  # Remove absolute paths from `configure' & co.; build out-of-tree.
  preConfigure = ''
    export PWD_P=$(type -tP pwd)
    for i in configure io/ftwtest-sh; do
        # Can't use substituteInPlace here because replace hasn't been
        # built yet in the bootstrap.
        sed -i "$i" -e "s^/bin/pwd^$PWD_P^g"
    done

    mkdir ../build
    cd ../build

    configureScript="`pwd`/../$sourceRoot/configure"

    ${lib.optionalString (stdenv.cc.libc != null)
      ''makeFlags="$makeFlags BUILD_LDFLAGS=-Wl,-rpath,${stdenv.cc.libc}/lib"''
    }


  '' + lib.optionalString (cross != null) ''
    sed -i s/-lgcc_eh//g "../$sourceRoot/Makeconfig"

    cat > config.cache << "EOF"
    libc_cv_forced_unwind=yes
    libc_cv_c_cleanup=yes
    libc_cv_gnu89_inline=yes
    # Only due to a problem in gcc configure scripts:
    libc_cv_sparc64_tls=${if cross.withTLS then "yes" else "no"}
    EOF

    export BUILD_CC=gcc
    export CC="$crossConfig-gcc"
    export AR="$crossConfig-ar"
    export RANLIB="$crossConfig-ranlib"
  '';

  preBuild = lib.optionalString withGd "unset NIX_DONT_SET_RPATH";

  meta = {
    homepage = http://www.gnu.org/software/libc/;
    description = "The GNU C Library";

    longDescription =
      '' Any Unix-like operating system needs a C library: the library which
         defines the "system calls" and other basic facilities such as
         open, malloc, printf, exit...

         The GNU C library is used as the C library in the GNU system and
         most systems with the Linux kernel.
      '';

    license = lib.licenses.lgpl2Plus;

    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.linux;
  } // meta;
}

// lib.optionalAttrs (cross != null) {
  preInstall = null; # clobber the native hook

  dontStrip = true;

  separateDebugInfo = false; # this is currently broken for crossDrv

  # To avoid a dependency on the build system 'bash'.
  preFixup = ''
    rm $bin/bin/{ldd,tzselect,catchsegv,xtrace}
  '';
})
