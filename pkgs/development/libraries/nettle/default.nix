{ fetchurl, stdenv, gmp, gnum4 }:

stdenv.mkDerivation rec {
  name = "nettle-2.1";

  src = fetchurl {
    # Eventually use `mirror://gnu/'.
    url = "ftp://ftp.lysator.liu.se/pub/security/lsh/${name}.tar.gz";
    sha256 = "0knp778738dpgbcj1yz54a7jsvmarfiafzl05z086bc470z6plmp";
  };

  buildInputs = [ gmp gnum4 ];

  doCheck = (stdenv.system != "i686-cygwin");

  patches = stdenv.lib.optional (stdenv.system == "i686-cygwin")
              ./cygwin.patch;

  meta = {
    description = "GNU Nettle, a cryptographic library";

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

     license = "GPLv2+";

     homepage = http://www.lysator.liu.se/~nisse/nettle/;

     maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
