{ lib, stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "Regina-REXX";
  version = "3.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/regina-rexx/regina-rexx/${version}/${pname}-${version}.tar.gz";
    sha256 = "1vpksnjmg6y5zag9li6sxqxj2xapgalfz8krfxgg49vyk0kdy4sx";
  };

  buildInputs = [ ncurses ];

  configureFlags = [
    "--libdir=$(out)/lib"
  ];

  meta = with lib; {
    description = "REXX interpreter";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };
}
