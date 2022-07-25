{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, cppunit
, swig
, boost
, log4cpp
, python
, libosmocore
, osmosdr
, thrift
, gmp
, fftwFloat
, gnuradio
}:

mkDerivation {
  pname = "gr-gsm";
  version = "2021-05-05";
  src = fetchFromGitHub {
    owner = "ptrkrysik";
    repo = "gr-gsm";
    rev = "2de47e28ce1fb9a518337bfc0add36c8e3cff5eb";
    sha256 = "sha256-OD3sVBBG+OoJ2f5CJ6KcdpVCgJWNdDjA9kiIuTklyPc=";
  };
  disabledForGRafter = "3.9";

  # grcc complains about grgsm_livemon being an invalid block
  # so just don't try to compile it
  cmakeFlags = [ "-DENABLE_GRCC=OFF" ];

  nativeBuildInputs = [
    cmake
    pkg-config
    swig
    python
  ];

  buildInputs = [
    cppunit
    log4cpp
    boost
    libosmocore
    osmosdr
    gmp
    fftwFloat
  ] ++ lib.optionals (gnuradio.hasFeature "gr-ctrlport") [
    thrift
    python.pkgs.thrift
  ];

  meta = with lib; {
    description = "Gnuradio block for gsm";
    homepage = "https://github.com/ptrkrysik/gr-gsm";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mog ];
  };
}
