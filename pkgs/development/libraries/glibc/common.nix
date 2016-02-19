/* Build configuration used to build glibc, Info files, and locale
   information.  */

cross:

{ name, fetchurl, fetchgit ? null, stdenv, installLocales ? false
, gccCross ? null, kernelHeaders ? null
, machHeaders ? null, hurdHeaders ? null, libpthreadHeaders ? null
, mig ? null
, profilingLibraries ? false, meta
, withGd ? false, gd ? null, libpng ? null
, preConfigure ? "", ... }@args:

let

  version = "2.21";

in

assert cross != null -> gccCross != null;
assert mig != null -> machHeaders != null;
assert machHeaders != null -> hurdHeaders != null;
assert hurdHeaders != null -> libpthreadHeaders != null;

stdenv.mkDerivation ({
  inherit kernelHeaders installLocales;

  # The host/target system.
  crossConfig = if cross != null then cross.config else null;

  inherit (stdenv) is64bit;

  enableParallelBuilding = true;

  /* Don't try to apply these patches to the Hurd's snapshot, which is
     older.  */
  patches = stdenv.lib.optionals (hurdHeaders == null)
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

      ./security-4a28f4d5.patch
      ./security-bdf1ff05.patch
      ./cve-2014-8121.patch
      ./cve-2015-1781.patch
      ./cve-2015-7547.patch

      ./glibc-locale-incompatibility.patch
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
      "--localedir=/var/run/current-system/sw/lib/locale"
      "libc_cv_ssp=no"
      (if kernelHeaders != null
       then "--with-headers=${kernelHeaders}/include"
       else "--without-headers")
      (if profilingLibraries
       then "--enable-profile"
       else "--disable-profile")
    ] ++ stdenv.lib.optionals (cross == null && kernelHeaders != null) [
      "--enable-kernel=2.6.32"
    ] ++ stdenv.lib.optionals (cross != null) [
      (if cross.withTLS then "--with-tls" else "--without-tls")
      (if cross.float == "soft" then "--without-fp" else "--with-fp")
    ] ++ stdenv.lib.optionals (cross != null
          && cross.platform ? kernelMajor
          && cross.platform.kernelMajor == "2.6") [
      "--enable-kernel=2.6.0"
      "--with-__thread"
    ] ++ stdenv.lib.optionals (cross == null && stdenv.isArm) [
      "--host=arm-linux-gnueabi"
      "--build=arm-linux-gnueabi"

      # To avoid linking with -lgcc_s (dynamic link)
      # so the glibc does not depend on its compiler store path
      "libc_cv_as_needed=no"
    ] ++ stdenv.lib.optional withGd "--with-gd";

  installFlags = [ "sysconfdir=$(out)/etc" ];

  buildInputs = stdenv.lib.optionals (cross != null) [ gccCross ]
    ++ stdenv.lib.optional (mig != null) mig
    ++ stdenv.lib.optionals withGd [ gd libpng ];

  # Needed to install share/zoneinfo/zone.tab.  Set to impure /bin/sh to
  # prevent a retained dependency on the bootstrap tools in the stdenv-linux
  # bootstrap.
  BASH_SHELL = "/bin/sh";

  # Workaround for this bug:
  #   http://sourceware.org/bugzilla/show_bug.cgi?id=411
  # I.e. when gcc is compiled with --with-arch=i686, then the
  # preprocessor symbol `__i686' will be defined to `1'.  This causes
  # the symbol __i686.get_pc_thunk.dx to be mangled.
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString (stdenv.system == "i686-linux") "-U__i686"
    + " -Wno-error=strict-prototypes";
}

# Remove the `gccCross' attribute so that the *native* glibc store path
# doesn't depend on whether `gccCross' is null or not.
// (removeAttrs args [ "gccCross" "fetchurl" "fetchgit" "withGd" "gd" "libpng" ]) //

{
  name = name + "-${version}" +
    stdenv.lib.optionalString (cross != null) "-${cross.config}";

  src =
    if hurdHeaders != null
    then fetchgit {
      # Shamefully the "official" glibc won't build on GNU, so use the one
      # maintained by the Hurd folks, `tschwinge/Roger_Whittaker' branch.
      # See <http://www.gnu.org/software/hurd/source_repositories/glibc.html>.
      url = "git://git.sv.gnu.org/hurd/glibc.git";
      sha256 = "cecec9dd5a2bafc875c56b058b6d7628a22b250b53747513dec304f31ffdb82d";
      rev = "d3cdecf18e6550b0984a42b43ed48c5fb26501e1";
    }
    else fetchurl {
      url = "mirror://gnu/glibc/glibc-${version}.tar.gz";
      sha256 = "0f4prv4c0fcpi85wv4028wqxn075197gwxhgf0vp571fiw2pi3wd";
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

    ${stdenv.lib.optionalString (stdenv.cc.libc != null)
      ''makeFlags="$makeFlags BUILD_LDFLAGS=-Wl,-rpath,${stdenv.cc.libc}/lib"''
    }

    ${preConfigure}
  '';

  meta = {
    homepage = http://www.gnu.org/software/libc/;
    description = "The GNU C Library"
      + stdenv.lib.optionalString (hurdHeaders != null) ", for GNU/Hurd";

    longDescription =
      '' Any Unix-like operating system needs a C library: the library which
         defines the "system calls" and other basic facilities such as
         open, malloc, printf, exit...

         The GNU C library is used as the C library in the GNU system and
         most systems with the Linux kernel.
      '';

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = [ ];
    #platforms = stdenv.lib.platforms.linux;
  } // meta;
}

// stdenv.lib.optionalAttrs withGd {
  preBuild = "unset NIX_DONT_SET_RPATH";
}

// stdenv.lib.optionalAttrs (name == "glibc-locales") {
  hardening_stackprotector = false;
}

// stdenv.lib.optionalAttrs (hurdHeaders != null) {
  # Work around the fact that the configure snippet that looks for
  # <hurd/version.h> does not honor `--with-headers=$sysheaders' and that
  # glibc expects Mach, Hurd, and pthread headers to be in the same place.
  CPATH = "${hurdHeaders}/include:${machHeaders}/include:${libpthreadHeaders}/include";

  # Install NSS stuff in the right place.
  # XXX: This will be needed for all new glibcs and isn't Hurd-specific.
  makeFlags = ''vardbdir="$out/var/db"'';
})
