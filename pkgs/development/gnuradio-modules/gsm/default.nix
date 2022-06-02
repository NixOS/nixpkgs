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
}:

mkDerivation {
  pname = "gr-gsm";
  version = "2016-08-25";
  src = fetchFromGitHub {
    owner = "ptrkrysik";
    repo = "gr-gsm";
    rev = "3ca05e6914ef29eb536da5dbec323701fbc2050d";
    sha256 = "13nnq927kpf91iqccr8db9ripy5czjl5jiyivizn6bia0bam2pvx";
  };
  disabledForGRafter = "3.8";

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
  ];

  meta = with lib; {
    description = "Gnuradio block for gsm";
    homepage = "https://github.com/ptrkrysik/gr-gsm";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mog ];
  };
}
