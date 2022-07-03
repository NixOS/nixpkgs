{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "h11";
  version = "0.13.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cIE8ETUIeiSKTTjMDhoBgf+rIYgUGpPq9WeUDDlX/wY=";
  };

  checkInputs = [ pytestCheckHook ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Pure-Python, bring-your-own-I/O implementation of HTTP/1.1";
    homepage = "https://github.com/python-hyper/h11";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
