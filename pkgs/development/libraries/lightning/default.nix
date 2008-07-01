{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "lightning-1.2c";

  src = fetchurl {
    url = "ftp://alpha.gnu.org/gnu/lightning/${name}.tar.gz";
    sha256 = "00ss2b75msj4skkda9fs5df3bfpi8bwbckci8g0pwd3syppb3qdl";
  };

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/lightning/;
    description = "GNU lightning, a run-time code generation library";

    longDescription = ''
      GNU lightning is a library that generates assembly language code
      at run-time; it is very fast, making it ideal for Just-In-Time
      compilers, and it abstracts over the target CPU, as it exposes
      to the clients a standardized RISC instruction set inspired by
      the MIPS and SPARC chips.
    '';

    license = "LGPLv3+";
  };
}