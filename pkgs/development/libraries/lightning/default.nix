{ fetchurl, stdenv, binutils }:

stdenv.mkDerivation rec {
  name = "lightning-2.0.4";

  src = fetchurl {
    url = "ftp://alpha.gnu.org/gnu/lightning/${name}.tar.gz";
    sha256 = "1lrckrx51d5hrv66bc99fd4b7g2wwn4vr304hwq3glfzhb8jqcdy";
  };

  # Needs libopcodes.so  from binutils for 'make check'
  buildInputs = [ binutils ];

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
