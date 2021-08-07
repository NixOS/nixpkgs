{ lib, mkDerivation, fetchFromGitHub, cmake, qtbase, kcolorpicker, qttools }:

mkDerivation rec {
  pname = "kimageannotator";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "ksnip";
    repo = "kImageAnnotator";
    rev = "v${version}";
    sha256 = "0hfvrd78lgwd7bccz0fx2pr7g0v3s401y5plra63rxwk55ffkxf8";
  };

  nativeBuildInputs = [ cmake qttools ];
  buildInputs = [ qtbase kcolorpicker ];

  meta = with lib; {
    description = "Tool for annotating images";
    homepage = "https://github.com/ksnip/kImageAnnotator";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ fliegendewurst ];
    platforms = platforms.linux;
  };
}
