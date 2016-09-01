/* Build configuration used to build glibc, Info files, and locale
   information.  */

cross:

{ name, fetchurl, lib, stdenv, installLocales ? false
, gccCross ? null, linuxHeaders ? null
, profilingLibraries ? false, meta
, withGd ? false, gd ? null, libpng ? null
, preConfigure ? "", ... }@args:

let
  version = "2.24";
  sha256 = "1ghzp41ryvsqxn4rhrm8r25wc33m2jf8zrcc1pj3jxyk8ad9a0by";
in

assert cross != null -> gccCross != null;

stdenv.mkDerivation ({
  inherit linuxHeaders installLocales;

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
    ];

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
      "libc_cv_ssp=no"
      (if linuxHeaders != null
       then "--with-headers=${linuxHeaders}/include"
       else "--without-headers")
      (if profilingLibraries
       then "--enable-profile"
       else "--disable-profile")
    ] ++ lib.optionals (cross == null && linuxHeaders != null) [
      "--enable-kernel=2.6.32"
    ] ++ lib.optionals (cross != null) [
      (if cross.withTLS then "--with-tls" else "--without-tls")
      (if cross.float == "soft" then "--without-fp" else "--with-fp")
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

  buildInputs = lib.optionals (cross != null) [ gccCross ]
    ++ lib.optionals withGd [ gd libpng ];

  # Needed to install share/zoneinfo/zone.tab.  Set to impure /bin/sh to
  # prevent a retained dependency on the bootstrap tools in the stdenv-linux
  # bootstrap.
  BASH_SHELL = "/bin/sh";

  # Workaround for this bug:
  #   http://sourceware.org/bugzilla/show_bug.cgi?id=411
  # I.e. when gcc is compiled with --with-arch=i686, then the
  # preprocessor symbol `__i686' will be defined to `1'.  This causes
  # the symbol __i686.get_pc_thunk.dx to be mangled.
  NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.system == "i686-linux") "-U__i686"
    + " -Wno-error=strict-prototypes";
}

# Remove the `gccCross' attribute so that the *native* glibc store path
# doesn't depend on whether `gccCross' is null or not.
// (removeAttrs args [ "lib" "gccCross" "fetchurl" "withGd" "gd" "libpng" ]) //

{
  name = name + "-${version}" +
    lib.optionalString (cross != null) "-${cross.config}";

  src = fetchurl {
    url = "mirror://gnu/glibc/glibc-${version}.tar.gz";
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

    ${preConfigure}
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
})
