{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "h11";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hk0nll6qazsambp3kl8cxxsbl4gv5y9252qadyk0jky0sv2q8j7";
  };

  checkInputs = [ pytestCheckHook ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Pure-Python, bring-your-own-I/O implementation of HTTP/1.1";
    homepage = "https://github.com/python-hyper/h11";
    license = licenses.mit;
  };
}
