{ lib, mkDerivation, fetchFromGitHub, cmake, qtbase, kcolorpicker, qttools }:

mkDerivation rec {
  pname = "kimageannotator";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ksnip";
    repo = "kImageAnnotator";
    rev = "v${version}";
    sha256 = "sha256-fWMaat5IguEZwoEJiEjGrWIbOqdJhs25qOebxpWVQQk=";
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
