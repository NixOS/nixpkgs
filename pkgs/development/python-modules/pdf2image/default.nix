{ lib
, buildPythonPackage
, fetchPypi
, pillow
, poppler_utils
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pdf2image";
<<<<<<< HEAD
  version = "1.16.3";
=======
  version = "1.16.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-dCCIEMLO9NnjR3abjmKlIwOYLdtPLf10THq0uUCuKH4=";
=======
    hash = "sha256-hnYQke7jX0ZB6pjf3bJUJUNh0Bi+aYoZmv98HTczGAM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    # Only replace first match in file
    sed -i '0,/poppler_path=None/s||poppler_path="${poppler_utils}/bin"|' pdf2image/pdf2image.py
  '';

  propagatedBuildInputs = [
    pillow
  ];

  pythonImportsCheck = [
    "pdf2image"
  ];

  meta = with lib; {
    description = "Module that wraps the pdftoppm utility to convert PDF to PIL Image object";
    homepage = "https://github.com/Belval/pdf2image";
    changelog = "https://github.com/Belval/pdf2image/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}
