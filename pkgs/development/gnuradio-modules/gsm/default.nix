{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, cppunit
, swig3
, boost
, logLib
, python
, libosmocore
, osmosdr
, gnuradioAtLeast
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
  disabled = gnuradioAtLeast "3.8";

  nativeBuildInputs = [
    cmake
    pkg-config
    swig3
    python
  ];

  buildInputs = [
    cppunit
    logLib
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
