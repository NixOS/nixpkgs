{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  requests,
  pytestCheckHook,
  mock,
}:

buildPythonPackage rec {
  pname = "linode-api";
  version = "5.16.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  # Sources from Pypi exclude test fixtures
  src = fetchFromGitHub {
    owner = "linode";
    repo = "python-linode-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-B90BfuAqyncJPIvcni7bthiwSfmeL9CqeTYT1/y5TNY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "linode_api4" ];

  meta = with lib; {
    description = "Python library for the Linode API v4";
    homepage = "https://github.com/linode/python-linode-api";
    license = licenses.bsd3;
    maintainers = with maintainers; [ glenns ];
  };
}
