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
  version = "5.0.0";
  disabled = pythonOlder "3.6";

  # Sources from Pypi exclude test fixtures
  src = fetchFromGitHub {
    owner = "linode";
    repo = "python-linode-api";
    rev = version;
    sha256 = "0lqi15vks4fxbki1l7n1bfzygjy3w17d9wchjxvp22ijmas44yai";
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
