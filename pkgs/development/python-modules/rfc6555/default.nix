{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "rfc6555";
  version = "0.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Lmwgusc4EQlF0GHmMTUxWzUCjBk19cvurNwbOnT+1jM=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Disabling tests that require a functional DNS IPv{4,6} stack to pass
    "test_create_connection_has_proper_timeout"
  ];

  pythonImportsCheck = [ "rfc6555" ];

  meta = with lib; {
    description = "Python implementation of the Happy Eyeballs Algorithm";
    homepage = "https://github.com/sethmlarson/rfc6555";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
