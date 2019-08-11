{ stdenv, fetchurl, fastnlo, rivet, pkgconfig }:

stdenv.mkDerivation rec {
  name = "mcgrid-${version}";
  version = "2.0.2";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/mcgrid/${name}.tar.gz";
    sha256 = "1mw82x7zqbdchnd6shj3dirsav5i2cndp2hjwb8a8xdh4xh9zvfy";
  };

  buildInputs = [ fastnlo rivet ];
  propagatedNativeBuildInputs = [ pkgconfig ];

  preConfigure = ''
    substituteInPlace mcgrid.pc.in \
      --replace "Cflags:" "Cflags: -std=c++11"
  '';

  CXXFLAGS = "-std=c++11";
  enableParallelBuilding = true;

  meta = {
    description = "A software package that provides access to the APPLgrid and fastNLO interpolation tools for Monte Carlo event generator codes, allowing for fast and flexible variations of scales, coupling parameters and PDFs in cutting edge leading- and next-to-leading-order QCD calculations";
    license     = stdenv.lib.licenses.gpl3;
    homepage    = http://mcgrid.hepforge.org;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
