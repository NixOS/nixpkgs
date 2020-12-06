{ stdenv, fetchFromGitHub, gfortran, lhapdf, python2, zlib }:

stdenv.mkDerivation rec {
  pname = "apfel";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "scarrazza";
    repo = "apfel";
    rev = version;
    sha256 = "13n5ygbqvskg3qq5n4sff1nbii0li0zf1vqissai7x0hynxgy7p6";
  };

  buildInputs = [ gfortran lhapdf python2 zlib ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A PDF Evolution Library";
    license     = licenses.gpl3;
    homepage    = "https://apfel.mi.infn.it/";
    platforms   = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
