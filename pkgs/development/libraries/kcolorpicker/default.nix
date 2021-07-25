{ lib, mkDerivation, fetchFromGitHub, cmake, qtbase }:

mkDerivation rec {
  pname = "kcolorpicker";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "ksnip";
    repo = "kColorPicker";
    rev = "v${version}";
    sha256 = "1167xwk75yiz697vddbz3lq42l7ckhyl2cvigy4m05qgg9693ksd";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase ];

  meta = with lib; {
    description = "Qt based Color Picker with popup menu";
    homepage = "https://github.com/ksnip/kColorPicker";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ fliegendewurst ];
    platforms = platforms.linux;
  };
}
