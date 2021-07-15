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
, gmp
, mpir
, fftwFloat
, icu
}:

mkDerivation rec {
  pname = "gr-ais";
  version = "2020-08-13";
  src = fetchFromGitHub {
    owner = "bistromath";
    repo = "gr-ais";
    rev = "2162103226f3dae43c8c2ab23b79483b84346665";
    sha256 = "1vackka34722d8pcspfwj0j6gc9ic7dqq64sgkrpjm94sh3bmb0b";
  };
  disabledForGRafter = "3.9";

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
    gmp
    mpir
    fftwFloat
    icu
  ];

  meta = with lib; {
    description = "Gnuradio block for ais";
    homepage = "https://github.com/bistromath/gr-ais";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mog ];
  };
}
