{ lib, mkDerivation, fetchFromGitHub, cmake, qtbase, kcolorpicker, qttools }:

mkDerivation rec {
  pname = "kimageannotator";
<<<<<<< HEAD
  version = "0.6.1";
=======
  version = "0.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ksnip";
    repo = "kImageAnnotator";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-lNoYAJ5yTC5H0gWPVkBGhLroRhFCPyC1DsVBy0IrqL4=";
=======
    sha256 = "sha256-fWMaat5IguEZwoEJiEjGrWIbOqdJhs25qOebxpWVQQk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
