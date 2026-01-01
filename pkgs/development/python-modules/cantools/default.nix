{
  lib,
  argparse-addons,
  bitstruct,
  buildPythonPackage,
  python-can,
  crccheck,
  diskcache,
  fetchPypi,
  matplotlib,
  parameterized,
  pytest-freezegun,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  textparser,
}:

buildPythonPackage rec {
  pname = "cantools";
<<<<<<< HEAD
  version = "41.0.2";
=======
  version = "41.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-XJGmbl4DpKxXJ/ICB98dpWgXSKFUwryF71Mv754BCdE=";
=======
    hash = "sha256-WycDUgKJuRFR5fPFT8wBxoijgrqDqjf6RnQxV4Pl8uk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    argparse-addons
    bitstruct
    python-can
    crccheck
    diskcache
    textparser
  ];

  optional-dependencies.plot = [ matplotlib ];

  nativeCheckInputs = [
    parameterized
    pytest-freezegun
    pytestCheckHook
  ]
  ++ optional-dependencies.plot;

  pythonImportsCheck = [ "cantools" ];

<<<<<<< HEAD
  meta = {
    description = "Tools to work with CAN bus";
    homepage = "https://github.com/cantools/cantools";
    changelog = "https://github.com/cantools/cantools/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gray-heron ];
=======
  meta = with lib; {
    description = "Tools to work with CAN bus";
    homepage = "https://github.com/cantools/cantools";
    changelog = "https://github.com/cantools/cantools/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gray-heron ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "cantools";
  };
}
