{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  requests,
  cryptography,
  responses,
}:
buildPythonPackage rec {
  pname = "python-transip";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "roaldnefs";
    repo = "python-transip";
    tag = "v${version}";
    hash = "sha256-HjlUwItkR81dyFGfY/YbHXI5k/IWUgzfikw5i4+yNWU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
    cryptography
  ];

  pythonImportsCheck = [
    "transip"
  ];

  nativeCheckInputs = [
    responses
    pytestCheckHook
  ];

  meta = {
    description = "Python wrapper for the TransIP REST API V6";
    homepage = "https://github.com/roaldnefs/python-transip";
    changelog = "https://github.com/roaldnefs/python-transip/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.provokateurin ];
  };
}
