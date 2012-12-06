/* Build configuration used to build glibc, Info files, and locale
   information.  */

cross :

{ name, fetchurl, stdenv, installLocales ? false
, gccCross ? null, kernelHeaders ? null
, machHeaders ? null, hurdHeaders ? null, libpthreadHeaders ? null
, mig ? null, fetchgit ? null
, profilingLibraries ? false, meta
, preConfigure ? "", recentGcc ? true, ... }@args :

let
  # For GNU/Hurd, see below.
  version = if hurdHeaders != null then "20120223" else "2.13";

  needsPortsNative = stdenv.isMips || stdenv.isArm;
  needsPortsCross = cross.arch == "mips" || cross.arch == "arm";
  needsPorts =
    if (stdenv ? cross) && stdenv.cross != null && hurdHeaders == null then true
    else if cross == null then needsPortsNative
    else needsPortsCross;

  srcPorts = fetchurl {
    url = "mirror://gnu/glibc/glibc-ports-2.13.tar.bz2";
    sha256 = "0npffql62m1xba15l1wkaqf2p0l2bvb33720gx28764jmq0la75i";
  };

in

assert (cross != null) -> (gccCross != null);

assert (mig != null) -> (machHeaders != null);
assert (machHeaders != null) -> (hurdHeaders != null);
assert (hurdHeaders != null) -> (libpthreadHeaders != null);
assert (hurdHeaders != null) -> (fetchgit != null);

stdenv.mkDerivation ({
  inherit kernelHeaders installLocales;

  # The host/target system.
  crossConfig = if (cross != null) then cross.config else null;

  inherit (stdenv) is64bit;

  enableParallelBuilding = true;

  patches =
    stdenv.lib.optional (fetchgit == null)
    /* Fix for NIXPKGS-79: when doing host name lookups, when
       nsswitch.conf contains a line like

         hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4

       don't return an error when mdns4_minimal can't be found.  This
       is a bug in Glibc: when a service can't be found, NSS should
       continue to the next service unless "UNAVAIL=return" is set.
       ("NOTFOUND=return" refers to the service returning a NOTFOUND
       error, not the service itself not being found.)  The reason is
       that the "status" variable (while initialised to UNAVAIL) is
       outside of the loop that iterates over the services, the
       "files" service sets status to NOTFOUND.  So when the call to
       find "mdns4_minimal" fails, "status" will still be NOTFOUND,
       and it will return instead of continuing to "dns".  Thus, the
       line

         hosts: mdns4_minimal [NOTFOUND=return] dns mdns4

       does work because "status" will contain UNAVAIL after the
       failure to find mdns4_minimal. */
    ./nss-skip-unavail.patch
  ++ [
    /* Have rpcgen(1) look for cpp(1) in $PATH.  */
    ./rpcgen-path.patch

    /* Allow nixos and nix handle the locale-archive. */
    ./nix-locale-archive.patch
  ]

  ++ (stdenv.lib.optional (hurdHeaders == null)

      /* Don't use /etc/ld.so.cache, for non-NixOS systems.  Currently
         disabled on GNU/Hurd, which uses a more recent libc snapshot. */
         ./dont_use_system_ld_so_cache.patch )

  ++ [
    /* Without this patch many KDE binaries crash. */
    ./glibc-elf-localscope.patch
  ] ++ stdenv.lib.optional installLocales ./catalan-firstdays.patch;

  postPatch = ''
    # Needed for glibc to build with the gnumake 3.82
    # http://comments.gmane.org/gmane.linux.lfs.support/31227
    sed -i 's/ot \$/ot:\n\ttouch $@\n$/' manual/Makefile

    # nscd needs libgcc, and we don't want it dynamically linked
    # because we don't want it to depend on bootstrap-tools libs.
    echo "LDFLAGS-nscd += -static-libgcc" >> nscd/Makefile
  '';

  configureFlags = [
    "-C"
    "--enable-add-ons"
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
    "--enable-kernel=2.6.35"
  ] ++ stdenv.lib.optionals (cross != null) [
    (if cross.withTLS then "--with-tls" else "--without-tls")
    (if cross.float == "soft" then "--without-fp" else "--with-fp")
  ] ++ stdenv.lib.optionals (cross != null
        && cross.platform ? kernelMajor
        && cross.platform.kernelMajor == "2.6") [
    "--enable-kernel=2.6.0"
    "--with-__thread"
  ] ++ stdenv.lib.optionals (cross == null &&
       (stdenv.system == "armv5tel-linux") ||
       (!recentGcc && stdenv.platform.name == "raspberrypi")) [
    "--host=arm-linux-gnueabi"
    "--build=arm-linux-gnueabi"
    "--without-fp"

    # To avoid linking with -lgcc_s (dynamic link)
    # so the glibc does not depend on its compiler store path
    "libc_cv_as_needed=no"
  ] ++ stdenv.lib.optionals (cross == null && recentGcc && stdenv.platform.name == "raspberrypi") [
    "--host=arm-linux-gnueabihf"
    "--build=arm-linux-gnueabihf"
    "--with-fp"

    # To avoid linking with -lgcc_s (dynamic link)
    # so the glibc does not depend on its compiler store path
    "libc_cv_as_needed=no"
  ];

  installFlags = [ "sysconfdir=$(out)/etc" ];
  
  buildInputs = stdenv.lib.optionals (cross != null) [ gccCross ]
    ++ stdenv.lib.optional (mig != null) mig;

  # Needed to install share/zoneinfo/zone.tab.  Set to impure /bin/sh to
  # prevent a retained dependency on the bootstrap tools in the stdenv-linux
  # bootstrap.
  BASH_SHELL = "/bin/sh";

  # Workaround for this bug:
  #   http://sourceware.org/bugzilla/show_bug.cgi?id=411
  # I.e. when gcc is compiled with --with-arch=i686, then the
  # preprocessor symbol `__i686' will be defined to `1'.  This causes
  # the symbol __i686.get_pc_thunk.dx to be mangled.
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString (stdenv.system == "i686-linux") "-U__i686";
}

# Remove the `gccCross' attribute so that the *native* glibc store path
# doesn't depend on whether `gccCross' is null or not.
// (removeAttrs args [ "gccCross" ]) //

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
      url = "mirror://gnu/glibc/glibc-${version}.tar.bz2";
      sha256 = "1cnv319ysc8nkwpqw6f6ymb6b8hbl0nyvyx48sddkrj50lmcjwq1";
    };

  # `fetchurl' is a function and thus should not be passed to the
  # `derivation' primitive.
  fetchurl = null;

  # Remove absolute paths from `configure' & co.; build out-of-tree.
  preConfigure = ''
    export PWD_P=$(type -tP pwd)
    for i in configure io/ftwtest-sh; do
        # Can't use substituteInPlace here because replace hasn't been
        # built yet in the bootstrap.
        sed -i "$i" -e "s^/bin/pwd^$PWD_P^g"
    done

    ${if needsPorts then "tar xvf ${srcPorts}" else ""}

    mkdir ../build
    cd ../build

    configureScript="`pwd`/../$sourceRoot/configure"

    ${preConfigure}
  '' + stdenv.lib.optionalString (cross == null
        && recentGcc
        && stdenv.platform.name == "raspberrypi") ''
    configureFlagsArray=("CFLAGS=-march=armv6 -mfpu=vfp -mhard-float")
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

    license = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    #platforms = stdenv.lib.platforms.linux;
  } // meta;
}

//

(if hurdHeaders != null
 then {
   # Work around the fact that the configure snippet that looks for
   # <hurd/version.h> does not honor `--with-headers=$sysheaders' and that
   # glibc expects Mach, Hurd, and pthread headers to be in the same place.
   CPATH = "${hurdHeaders}/include:${machHeaders}/include:${libpthreadHeaders}/include";

   # `fetchgit' is a function and thus should not be passed to the
   # `derivation' primitive.
   fetchgit = null;

   # Install NSS stuff in the right place.
   # XXX: This will be needed for all new glibcs and isn't Hurd-specific.
   makeFlags = ''vardbdir="$out/var/db"'';
 }
 else { }))
