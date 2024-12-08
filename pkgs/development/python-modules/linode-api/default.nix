{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  requests,
  polling,
  deprecated,
  pytestCheckHook,
  mock,
  httpretty,
}:

buildPythonPackage rec {
  pname = "linode-api";
  version = "5.22.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  # Sources from Pypi exclude test fixtures
  src = fetchFromGitHub {
    owner = "linode";
    repo = "python-linode-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-f9v9xhlOfSCKEWHmzi/tpoMIXccGwA6isoAAIZOf3r4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    requests
    polling
    deprecated
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    httpretty
  ];

  disabledTestPaths = [
    # needs api token
    "test/integration"
  ];

  pythonImportsCheck = [ "linode_api4" ];

  meta = with lib; {
    description = "Python library for the Linode API v4";
    homepage = "https://github.com/linode/python-linode-api";
    license = licenses.bsd3;
    maintainers = with maintainers; [ glenns ];
  };
}
