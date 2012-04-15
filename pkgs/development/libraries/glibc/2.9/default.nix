{ stdenv, fetchurl, kernelHeaders
, installLocales ? true
, profilingLibraries ? false
, gccCross ? null
}:
let
    cross = if gccCross != null then gccCross.target else null;
in
stdenv.mkDerivation rec {
  name = "glibc-2.9" +
    stdenv.lib.optionalString (cross != null) "-${cross.config}";

  builder = ./builder.sh;

  src = fetchurl {
    url = http://ftp.gnu.org/gnu/glibc/glibc-2.9.tar.bz2;
    sha256 = "0v53m7flx6qcx7cvrvvw6a4dx4x3y6k8nvpc4wfv5xaaqy2am2q9";
  };

  srcPorts = fetchurl {
    url = http://ftp.gnu.org/gnu/glibc/glibc-ports-2.9.tar.bz2;
    sha256 = "0r2sn527wxqifi63di7ns9wbjh1cainxn978w178khhy7yw9fk42";
  };

  inherit kernelHeaders installLocales;
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

    /* Support GNU Binutils 2.20 and above.  */
    ./binutils-2.20.patch

    ./binutils-ld.patch
  ];

  configureFlags = [
    "--enable-add-ons"
    "--with-headers=${kernelHeaders}/include"
    (if profilingLibraries then "--enable-profile" else "--disable-profile")
  ] ++ stdenv.lib.optionals (cross != null) [
    "--with-tls"
    "--enable-kernel=2.6.0"
    "--without-fp"
    "--with-__thread"
  ] ++ (if stdenv.isArm then [
    "--host=arm-linux-gnueabi"
    "--build=arm-linux-gnueabi"
    "--without-fp"
  ] else []);

  buildNativeInputs = stdenv.lib.optionals (cross != null) [ gccCross ];

  preInstall = if (cross != null) then ''
    mkdir -p $out/lib
    ln -s ${stdenv.gcc.gcc}/lib/libgcc_s.so.1 $out/lib/libgcc_s.so.1
  '' else "";

  postInstall = if (cross != null) then ''
    rm $out/lib/libgcc_s.so.1
  '' else "";

  # Workaround for this bug:
  #   http://sourceware.org/bugzilla/show_bug.cgi?id=411
  # I.e. when gcc is compiled with --with-arch=i686, then the
  # preprocessor symbol `__i686' will be defined to `1'.  This causes
  # the symbol __i686.get_pc_thunk.dx to be mangled.
  NIX_CFLAGS_COMPILE = "-U__i686";

  meta = {
    homepage = http://www.gnu.org/software/libc/;
    description = "The GNU C Library";
  };
}
