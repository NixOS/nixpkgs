{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  requests,
  pycryptodomex,
  pydantic-settings,
  pyjwkest,
  mako,
  cryptography,
  defusedxml,

  # tests
  pytestCheckHook,
  freezegun,
  responses,
  testfixtures,
}:

buildPythonPackage rec {
  pname = "oic";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CZ-NIC";
    repo = "pyoidc";
    tag = version;
    hash = "sha256-7qEK1HWLEGCKu+gDAfbyT1a+sM9fVOfjtkqZ33GWv6U=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
    pycryptodomex
    pydantic-settings
    pyjwkest
    mako
    cryptography
    defusedxml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    freezegun
    responses
    testfixtures
  ];

  pythonImportsCheck = [ "oic" ];

  meta = {
    description = "OpenID Connect implementation in Python";
    homepage = "https://github.com/CZ-NIC/pyoidc";
    changelog = "https://github.com/CZ-NIC/pyoidc/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
