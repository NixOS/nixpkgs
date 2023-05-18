{ lib, mkDerivation, fetchFromGitHub, cmake, qtbase }:

mkDerivation rec {
  pname = "kcolorpicker";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ksnip";
    repo = "kColorPicker";
    rev = "v${version}";
    sha256 = "sha256-ahmMj/yzQiRP9oJwDuhJGxe849kxNsoGFDZ2CGQNhKs=";
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
