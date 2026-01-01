{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  python-yakh,
  rich,

  # nativeCheckInputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "questo";
<<<<<<< HEAD
  version = "0.4.2";
=======
  version = "0.4.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "petereon";
    repo = "questo";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-1T8HRgIW9P5iX1a75Bn9XqiVMCPtL7tdQTpixPbTbv0=";
=======
    hash = "sha256-XCxSH2TSU4YdfyqfLpVSEeDeU1S24C+NezP1IL5qj/4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    python-yakh
    rich
  ];

  pythonImportsCheck = [
    "questo"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Library of extensible and modular CLI prompt elements";
    homepage = "https://github.com/petereon/questo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
