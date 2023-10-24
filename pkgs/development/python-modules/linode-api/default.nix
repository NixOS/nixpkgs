{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "linode-api";
  version = "5.7.2";
  disabled = pythonOlder "3.6";

  # Sources from Pypi exclude test fixtures
  src = fetchFromGitHub {
    owner = "linode";
    repo = "python-linode-api";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-RU/GyNYV05iYVNanMqKMmoksXWrxTQ2H2XvaIwSSslA=";
  };

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
