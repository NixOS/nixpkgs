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
  version = "41.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XJGmbl4DpKxXJ/ICB98dpWgXSKFUwryF71Mv754BCdE=";
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

  meta = {
    description = "Tools to work with CAN bus";
    homepage = "https://github.com/cantools/cantools";
    changelog = "https://github.com/cantools/cantools/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gray-heron ];
    mainProgram = "cantools";
  };
}
