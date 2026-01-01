{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  pytest-mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "countryguess";
<<<<<<< HEAD
  version = "0.4.8";
=======
  version = "0.4.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "plotski";
    repo = "countryguess";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-XP84p9zX9dKhNaTPLmSQrYdYmPjym+m3EZL5A8AbgfM=";
=======
    hash = "sha256-yZyEOFXwbaYAIDl6LoHkwoqlhVzqShY8ZXPasB6unQ8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "countryguess" ];

  meta = {
    description = "Fuzzy lookup of country information";
    homepage = "https://codeberg.org/plotski/countryguess";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
