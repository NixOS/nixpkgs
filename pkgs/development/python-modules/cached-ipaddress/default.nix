{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  propcache,
}:

buildPythonPackage rec {
  pname = "cached-ipaddress";
  version = "0.10.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "cached-ipaddress";
    tag = "v${version}";
    hash = "sha256-g6ffp08SXckCJthGICeuEqZ71XeLklKmz6Ziz/AHBOg=";
  };

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  dependencies = [ propcache ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cached_ipaddress" ];

  meta = with lib; {
    description = "Cache construction of ipaddress objects";
    homepage = "https://github.com/bdraco/cached-ipaddress";
    changelog = "https://github.com/bdraco/cached-ipaddress/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
