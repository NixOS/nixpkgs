{ lib, mkDerivation, fetchFromGitHub, cmake, qtbase, kcolorpicker, qttools }:

mkDerivation rec {
  pname = "kimageannotator";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "ksnip";
    repo = "kImageAnnotator";
    rev = "v${version}";
    sha256 = "sha256-dkZa+OhU3w4dUy/Edd0R2UFNYuIdeYe3H1SOtW5ario=";
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
