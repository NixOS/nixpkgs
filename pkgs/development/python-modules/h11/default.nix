{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, httpcore
, httpx
, wsproto
}:

buildPythonPackage rec {
  pname = "h11";
  version = "0.14.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jxn7vpnnJCD/NcALJ6NMuZN+kCqLgQ4siDAMbwo7aZ0=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    inherit httpcore httpx wsproto;
  };

  meta = with lib; {
    description = "Pure-Python, bring-your-own-I/O implementation of HTTP/1.1";
    homepage = "https://github.com/python-hyper/h11";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
