{ lib
, buildPythonPackage
, fetchPypi
, requests
, poetry-core
, keyring
}:

buildPythonPackage rec {
  pname = "deepl";
<<<<<<< HEAD
  version = "1.15.0";
=======
  version = "1.14.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-BRFC4R5d1gxHyEJI41Fi0Az8GqmDG7mQ6Fx/o23OGcE=";
=======
    hash = "sha256-jUHxyx+b1OICJHAs8lh5NVtl+MExyEYM/yfs2qz6fv4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    requests
    keyring
  ];

  # Requires internet access and an API key
  doCheck = false;

  pythonImportsCheck = [
    "deepl"
  ];

  meta = with lib; {
    description = "A language translation API that allows other computer programs to send texts and documents to DeepL's servers and receive high-quality translations";
    homepage = "https://github.com/DeepLcom/deepl-python";
    changelog = "https://github.com/DeepLcom/deepl-python/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ MaskedBelgian ];
  };
}
