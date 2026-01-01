{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  normality,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fingerprints";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alephdata";
    repo = "fingerprints";
    tag = version;
    hash = "sha256-Q+XCsuGMHPtOqB0SauVuYInR5FGMuG6aNhqiAwTJvSI=";
  };

  build-system = [ hatchling ];

  dependencies = [ normality ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fingerprints" ];

<<<<<<< HEAD
  meta = {
    description = "Library to generate entity fingerprints";
    homepage = "https://github.com/alephdata/fingerprints";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Library to generate entity fingerprints";
    homepage = "https://github.com/alephdata/fingerprints";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
