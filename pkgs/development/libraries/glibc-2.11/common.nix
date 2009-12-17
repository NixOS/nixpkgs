/* Build configuration used to build glibc, Info files, and locale
   information.  */

cross : { name, fetchurl, stdenv, installLocales ? false
, gccCross ? null, kernelHeaders ? null
, profilingLibraries ? false, meta, ... }@args :

let version = "2.11";
in
assert (cross != null) -> (gccCross != null);

stdenv.mkDerivation ({
  inherit kernelHeaders installLocales;

  # The host/target system.
  crossConfig = if (cross != null) then cross.config else null;

  inherit (stdenv) is64bit;

  patches = [
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

    /* Make it possible to override the locale-archive in NixOS. */
    ./locale-override.patch

    /* Have rpcgen(1) look for cpp(1) in $PATH.  */
    ./rpcgen-path.patch

    /* Make sure `nscd' et al. are linked against `libssp'.  */
    ./stack-protector-link.patch

    /* MOD_NANO definition, for ntp (taken from glibc upstream) */
    ./mod_nano.patch
  ];

  configureFlags = [
    "-C"
    "--enable-add-ons"
    (if kernelHeaders != null
     then "--with-headers=${kernelHeaders}/include"
     else "--without-headers")
    (if profilingLibraries
     then "--enable-profile"
     else "--disable-profile")
  ] ++ stdenv.lib.optionals (cross != null) [
    "--with-tls"
    "--enable-kernel=2.6.0"
    "--without-fp"
    "--with-__thread"
  ] ++ (if (stdenv.system == "armv5tel-linux") then [
    "--host=arm-linux-gnueabi"
    "--build=arm-linux-gnueabi"
    "--without-fp"
  ] else []);

  buildInputs = stdenv.lib.optionals (cross != null) [ gccCross ];

  # Needed to install share/zoneinfo/zone.tab.  Set to impure /bin/sh to
  # prevent a retained dependency on the bootstrap tools in the stdenv-linux
  # bootstrap.
  BASH_SHELL = "/bin/sh";
}

//

(if (stdenv.system == "i686-linux")
 then {
   # Workaround for this bug:
   #   http://sourceware.org/bugzilla/show_bug.cgi?id=411
   # I.e. when gcc is compiled with --with-arch=i686, then the
   # preprocessor symbol `__i686' will be defined to `1'.  This causes
   # the symbol __i686.get_pc_thunk.dx to be mangled.
   NIX_CFLAGS_COMPILE = "-U__i686";
 }
 else {})

 //

 args

 //

{
  name = args.name + "-${version}" +
    stdenv.lib.optionalString (cross != null) "-${cross.config}";

  src = fetchurl {
    url = "mirror://gnu/glibc/glibc-${version}.tar.bz2";
    sha256 = "0b6nbr89qmqcvzz26ggnw7gcxhvnzbc8z299h12wqjmcix4hxwcy";
  };

  srcPorts = fetchurl {
    url = "mirror://gnu/glibc/glibc-ports-${version}.tar.bz2";
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

    configureScript="../$sourceRoot/configure"

    ${if args ? preConfigure
      then args.preConfigure
      else ""}
  '';

  meta = ({
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
    }
    //
    args.meta
  );
})
