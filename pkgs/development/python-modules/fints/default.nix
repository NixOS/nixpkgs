{
  lib,
  buildPythonPackage,
  setuptools,
  fetchFromGitHub,
  bleach,
  lxml,
  mt-940,
  requests,
  sepaxml,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  version = "5.0.0";
  pname = "fints";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "python-fints";
    tag = "v${version}";
    hash = "sha256-ll2+PtcGQiY5nbQTKVetd2ecDBVSXgzWP4Vzzri1Trs=";
  };

  pythonRemoveDeps = [ "enum-tools" ];

  build-system = [ setuptools ];

  dependencies = [
    bleach
    lxml
    mt-940
    requests
    sepaxml
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "fints" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  meta = {
    homepage = "https://github.com/raphaelm/python-fints/";
    description = "Pure-python FinTS (formerly known as HBCI) implementation";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      dotlambda
    ];
  };
}
