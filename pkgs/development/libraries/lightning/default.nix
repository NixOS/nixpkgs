{ stdenv, fetchurl, binutils }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "lightning-${version}";
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://gnu/lightning/${name}.tar.gz";
    sha256 = "19j9nwl88k660045s40cbz5zrl1wpd2mcxnnc8qqnnaj311a58qz";
  };

  # Needs libopcodes.so from binutils for 'make check'
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
    maintainers = [ maintainers.AndersonTorres ];
    license = licenses.lgpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
