{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, python
, boost
, cppunit
, log4cpp
, osmosdr
}:

mkDerivation rec {
  pname = "gr-ais";
  version = "2015-12-20";
  src = fetchFromGitHub {
    owner = "bistromath";
    repo = "gr-ais";
    rev = "cdc1f52745853f9c739c718251830eb69704b26e";
    sha256 = "1vl3kk8xr2mh5lf31zdld7yzmwywqffffah8iblxdzblgsdwxfl6";
  };
  disabledForGRafter = "3.8";

  nativeBuildInputs = [
    cmake
    pkg-config
    python
  ];

  buildInputs = [
    cppunit
    osmosdr
    boost
    log4cpp
  ];

  meta = with lib; {
    description = "Gnuradio block for ais";
    homepage = "https://github.com/bistromath/gr-ais";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mog ];
  };
}
