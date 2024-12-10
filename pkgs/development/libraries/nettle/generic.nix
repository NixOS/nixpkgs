{ lib, stdenv, buildPackages, gmp, gnum4

# Version specific args
, version, src
}:

stdenv.mkDerivation {
  pname = "nettle";

  inherit version src;

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ gnum4 ];
  propagatedBuildInputs = [ gmp ];

  configureFlags =
    # runtime selection of HW-accelerated code; it's default since 3.7
    [ "--enable-fat" ]
    # Make sure the right <gmp.h> is found, and not the incompatible
    # /usr/include/mp.h from OpenSolaris.  See
    # <https://lists.gnu.org/archive/html/hydra-users/2012-08/msg00000.html>
    # for details.
    ++ lib.optional stdenv.hostPlatform.isSunOS "--with-include-path=${gmp.dev}/include";

  doCheck = (stdenv.hostPlatform.system != "i686-cygwin" && !stdenv.hostPlatform.isDarwin);

  enableParallelBuilding = true;

  patches = lib.optional (stdenv.hostPlatform.system == "i686-cygwin")
              ./cygwin.patch;

  meta = with lib; {
    description = "Cryptographic library";

    longDescription = ''
        Nettle is a cryptographic library that is designed to fit
        easily in more or less any context: In crypto toolkits for
        object-oriented languages (C++, Python, Pike, ...), in
        applications like LSH or GNUPG, or even in kernel space.  In
        most contexts, you need more than the basic cryptographic
        algorithms, you also need some way to keep track of available
        algorithms, their properties and variants.  You often have
        some algorithm selection process, often dictated by a protocol
        you want to implement.

        And as the requirements of applications differ in subtle and
        not so subtle ways, an API that fits one application well can
        be a pain to use in a different context.  And that is why
        there are so many different cryptographic libraries around.

        Nettle tries to avoid this problem by doing one thing, the
        low-level crypto stuff, and providing a simple but general
        interface to it.  In particular, Nettle doesn't do algorithm
        selection.  It doesn't do memory allocation. It doesn't do any
        I/O.
     '';

     license = licenses.gpl2Plus;

     homepage = "https://www.lysator.liu.se/~nisse/nettle/";

     platforms = platforms.all;
     maintainers = [ maintainers.vcunat ];
  };
}
