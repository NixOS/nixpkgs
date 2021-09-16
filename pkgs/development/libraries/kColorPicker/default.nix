{ stdenv
, lib
, cmake
, fetchFromGitHub
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "kColorPicker";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "ksnip";
    repo = "kColorPicker";
    rev = "v${version}";
    sha256 = "1167xwk75yiz697vddbz3lq42l7ckhyl2cvigy4m05qgg9693ksd";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    qtbase
  ];

  meta = with lib; {
    homepage = "https://github.com/ksnip/kImageAnnotator";
    description = "Tool for annotating images";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ x3ro ];
    platforms = platforms.linux;
  };
}
