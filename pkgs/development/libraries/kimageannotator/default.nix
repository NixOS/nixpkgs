{ lib, stdenv, fetchFromGitHub, cmake, qttools, qtbase, qtsvg, kcolorpicker }:

let
  isQt6 = lib.versions.major qtbase.version == "6";
in stdenv.mkDerivation rec {
  pname = "kimageannotator";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "ksnip";
    repo = "kImageAnnotator";
    rev = "v${version}";
    hash = "sha256-Dq9CM/D3nA7MaY9rfwqF/UAw/+1ptKLf3P8jhFdngKk=";
  };

  nativeBuildInputs = [ cmake qttools ];
  buildInputs = [ qtbase qtsvg ];
  propagatedBuildInputs = [ kcolorpicker ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_WITH_QT6" isQt6)
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ];

  # Library only
  dontWrapQtApps = true;

  meta = with lib; {
    description = "Tool for annotating images";
    homepage = "https://github.com/ksnip/kImageAnnotator";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ fliegendewurst ];
    platforms = platforms.linux;
  };
}
