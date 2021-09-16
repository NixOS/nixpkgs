{ stdenv
, lib
, cmake
, fetchFromGitHub
, kColorPicker
, qtbase
, qtsvg
, qttranslations
}:

stdenv.mkDerivation rec {
  pname = "kImageAnnotator";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "ksnip";
    repo = "kImageAnnotator";
    rev = "v${version}";
    sha256 = "07m3il928gwzzab349grpaksqqv4n7r6mn317sx2jly0x0bpv0rh";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    kColorPicker
    qtbase
    qtsvg
    qttranslations
  ];

  meta = with lib; {
    homepage = "https://github.com/ksnip/kImageAnnotator";
    description = "Tool for annotating images";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ x3ro ];
    platforms = platforms.linux;
  };
}
