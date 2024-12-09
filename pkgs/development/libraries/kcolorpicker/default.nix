{ lib, stdenv, fetchFromGitHub, cmake, qtbase }:

let
  isQt6 = lib.versions.major qtbase.version == "6";
in stdenv.mkDerivation rec {
  pname = "kcolorpicker";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "ksnip";
    repo = "kColorPicker";
    rev = "v${version}";
    hash = "sha256-FG/A4pDNuhGPOeJNZlsnX3paEy4ibJVWKxn8rVUGpN8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_WITH_QT6" isQt6)
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ];

  # Library only
  dontWrapQtApps = true;

  meta = with lib; {
    description = "Qt based Color Picker with popup menu";
    homepage = "https://github.com/ksnip/kColorPicker";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ fliegendewurst ];
    platforms = platforms.linux;
  };
}
