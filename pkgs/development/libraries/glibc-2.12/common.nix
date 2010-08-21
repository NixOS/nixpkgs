/* Build configuration used to build glibc, Info files, and locale
   information.  */

cross :

{ name, fetchurl, stdenv, installLocales ? false
, gccCross ? null, kernelHeaders ? null
, machHeaders ? null, hurdHeaders ? null, mig ? null, fetchgit ? null
, profilingLibraries ? false, meta
, preConfigure ? "", ... }@args :

let
  # For GNU/Hurd, see below.
  version = if hurdHeaders != null then "20100512" else "2.12.1";
in

assert (cross != null) -> (gccCross != null);

assert (mig != null) -> (machHeaders != null);
assert (machHeaders != null) -> (hurdHeaders != null);
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

    /* Make sure `nscd' et al. are linked against `libssp'.  */
    ./stack-protector-link.patch

    /* Fix for the check of -fgnu89-inline compiler flag */
    ./gnu89-inline.patch

    /* Allow nixos and nix handle the locale-archive. */
    ./nix-locale-archive.patch
  ];

  configureFlags = [
    "-C"
    "--enable-add-ons"
    "--localedir=/var/run/current-system/sw/lib/locale"
    (if kernelHeaders != null
     then "--with-headers=${kernelHeaders}/include"
     else "--without-headers")
    (if profilingLibraries
     then "--enable-profile"
     else "--disable-profile")
  ] ++ stdenv.lib.optionals (cross != null) [
    (if cross.withTLS then "--with-tls" else "--without-tls")
    (if cross.float == "soft" then "--without-fp" else "--with-fp")
    "--enable-kernel=2.6.0"
    "--with-__thread"
  ] ++ stdenv.lib.optionals (stdenv.system == "armv5tel-linux") [
    "--host=arm-linux-gnueabi"
    "--build=arm-linux-gnueabi"
    "--without-fp"
  ];
  
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
      sha256 = "f3590a54a9d897d121f91113949edbaaf3e30cdeacbb8d0a44de7b6564f6643e";
      rev = "df4c3faf0ccc848b5a8086c222bdb42679a9798f";
    }
    else fetchurl {
      url = "mirror://gnu/glibc/glibc-${version}.tar.bz2";
      sha256 = "01vlr473skl08xpcjz0b4lw23lsnskf5kx9s8nxwa4mwa9f137vm";
    };

  srcPorts = fetchurl {
    url = "mirror://gnu/glibc/glibc-ports-2.11.tar.bz2"; # FIXME: 2.12.1 unavailable.
    sha256 = "12b53f5k4gcr8rr1kg2ycf2701rygqsyf9r8gz4j3l9flaqi5liq";
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

    tar xvjf "$srcPorts"

    mkdir ../build
    cd ../build

    configureScript="`pwd`/../$sourceRoot/configure"

    ${preConfigure}
  '';

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

    license = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.linux;
  } // meta;
}

//

(if hurdHeaders != null
 then {
   # Work around the fact that the configure snippet that looks for
   # <hurd/version.h> does not honor `--with-headers=$sysheaders' and that
   # glibc expects both Mach and Hurd headers to be in the same place.
   CPATH = "${hurdHeaders}/include:${machHeaders}/include";

   # `fetchgit' is a function and thus should not be passed to the
   # `derivation' primitive.
   fetchgit = null;
 }
 else { }))
