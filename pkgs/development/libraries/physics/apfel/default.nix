{ stdenv, fetchFromGitHub, gfortran, lhapdf, python2 }:

stdenv.mkDerivation rec {
  name = "apfel-${version}";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "scarrazza";
    repo = "apfel";
    rev = version;
    sha256 = "13dvcc5ba6djflrcy5zf5ikaw8s78zd8ac6ickc0hxhbmx1gjb4j";
  };

  buildInputs = [ gfortran lhapdf python2 ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A PDF Evolution Library";
    license     = licenses.gpl3;
    homepage    = https://apfel.mi.infn.it/;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
