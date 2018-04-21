/* Build configuration used to build glibc, Info files, and locale
   information.  */

{ stdenv, lib
, buildPlatform, hostPlatform
, buildPackages
, fetchurl, fetchpatch ? null
, linuxHeaders ? null
, gd ? null, libpng ? null
, bison
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
  version = "2.27";
  patchSuffix = "";
  sha256 = "0wpwq7gsm7sd6ysidv0z575ckqdg13cr2njyfgrbgh4f65adwwji";
  cross = if buildPlatform != hostPlatform then hostPlatform else null;
in

assert withLinuxHeaders -> linuxHeaders != null;
assert withGd -> gd != null && libpng != null;

stdenv.mkDerivation ({
  inherit version installLocales;
  linuxHeaders = if withLinuxHeaders then linuxHeaders else null;

  # The host/target system.
  crossConfig = if cross != null then cross.config else null;

  inherit (stdenv) is64bit;

  enableParallelBuilding = true;

  patches =
    [
      /* Have rpcgen(1) look for cpp(1) in $PATH.  */
      ./rpcgen-path.patch

      /* Allow NixOS and Nix to handle the locale-archive. */
      ./nix-locale-archive.patch

      /* Don't use /etc/ld.so.cache, for non-NixOS systems.  */
      ./dont-use-system-ld-so-cache.patch

      /* Don't use /etc/ld.so.preload, but /etc/ld-nix.so.preload.  */
      ./dont-use-system-ld-so-preload.patch

      /* The command "getconf CS_PATH" returns the default search path
         "/bin:/usr/bin", which is inappropriate on NixOS machines. This
         patch extends the search path by "/run/current-system/sw/bin". */
      ./fix_path_attribute_in_getconf.patch

      /* Allow running with RHEL 6 -like kernels.  The patch adds an exception
        for glibc to accept 2.6.32 and to tag the ELFs as 2.6.32-compatible
        (otherwise the loader would refuse libc).
        Note that glibc will fully work only on their heavily patched kernels
        and we lose early mismatch detection on 2.6.32.

        On major glibc updates we should check that the patched kernel supports
        all the required features.  ATM it's verified up to glibc-2.26-131.
        # HOWTO: check glibc sources for changes in kernel requirements
        git log -p glibc-2.25.. sysdeps/unix/sysv/linux/x86_64/kernel-features.h sysdeps/unix/sysv/linux/kernel-features.h
        # get kernel sources (update the URL)
        mkdir tmp && cd tmp
        curl http://vault.centos.org/6.9/os/Source/SPackages/kernel-2.6.32-696.el6.src.rpm | rpm2cpio - | cpio -idmv
        tar xf linux-*.bz2
        # check syscall presence, for example
        less linux-*?/arch/x86/kernel/syscall_table_32.S
       */
      ./allow-kernel-2.6.32.patch
    ]
    ++ lib.optional stdenv.isx86_64 ./fix-x64-abi.patch
    ++ lib.optional stdenv.hostPlatform.isMusl
      (fetchpatch {
        name = "fix-with-musl.patch";
        url = "https://sourceware.org/bugzilla/attachment.cgi?id=10151&action=diff&collapsed=&headers=1&format=raw";
        sha256 = "18kk534k6da5bkbsy1ivbi77iin76lsna168mfcbwv4ik5vpziq2";
      });

  postPatch =
    ''
      # Needed for glibc to build with the gnumake 3.82
      # http://comments.gmane.org/gmane.linux.lfs.support/31227
      sed -i 's/ot \$/ot:\n\ttouch $@\n$/' manual/Makefile

      # nscd needs libgcc, and we don't want it dynamically linked
      # because we don't want it to depend on bootstrap-tools libs.
      echo "LDFLAGS-nscd += -static-libgcc" >> nscd/Makefile
    '';

  configureFlags =
    [ "-C"
      "--enable-add-ons"
      "--enable-obsolete-nsl"
      "--enable-obsolete-rpc"
      "--sysconfdir=/etc"
      "--enable-stackguard-randomization"
      (if withLinuxHeaders
       then "--with-headers=${linuxHeaders}/include"
       else "--without-headers")
      (if profilingLibraries
       then "--enable-profile"
       else "--disable-profile")
    ] ++ lib.optionals withLinuxHeaders [
      "--enable-kernel=3.2.0" # can't get below with glibc >= 2.26
    ] ++ lib.optionals (cross != null) [
      (if cross ? float && cross.float == "soft" then "--without-fp" else "--with-fp")
    ] ++ lib.optionals (cross != null) [
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

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ bison ];
  buildInputs = lib.optionals withGd [ gd libpng ];

  # Needed to install share/zoneinfo/zone.tab.  Set to impure /bin/sh to
  # prevent a retained dependency on the bootstrap tools in the stdenv-linux
  # bootstrap.
  BASH_SHELL = "/bin/sh";
}

// (removeAttrs args [ "withLinuxHeaders" "withGd" ]) //

{
  name = name + "-${version}${patchSuffix}";

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
    EOF
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
    rm -f $bin/bin/{ldd,tzselect,catchsegv,xtrace}
  '';
})
