{ stdenv, fetchurl, libopcodes }:

with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "lightning";
  version = "2.1.3";

  src = fetchurl {
    url = "mirror://gnu/lightning/${pname}-${version}.tar.gz";
    sha256 = "1jgxbq2cm51dzi3zhz38mmgwdcgs328mfl8iviw8dxn6dn36p1gd";
  };

  checkInputs = [ libopcodes ];

  doCheck = true;

  meta = {
    homepage = https://www.gnu.org/software/lightning/;
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
