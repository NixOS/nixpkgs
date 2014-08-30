{ fetchurl, stdenv, binutils }:

stdenv.mkDerivation rec {
  name = "lightning-2.0.5";

  src = fetchurl {
    url = "mirror://gnu/lightning/${name}.tar.gz";
    sha256 = "0jm9a8ddxc1v9hyzyv4ybg37fjac2yjqv1hkd262wxzqms36mdk5";
  };

  # Needs libopcodes.so  from binutils for 'make check'
  buildInputs = [ binutils ];

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/lightning/;
    description = "Run-time code generation library";

    longDescription = ''
      GNU lightning is a library that generates assembly language code
      at run-time; it is very fast, making it ideal for Just-In-Time
      compilers, and it abstracts over the target CPU, as it exposes
      to the clients a standardized RISC instruction set inspired by
      the MIPS and SPARC chips.
    '';

    license = stdenv.lib.licenses.lgpl3Plus;
  };
}
