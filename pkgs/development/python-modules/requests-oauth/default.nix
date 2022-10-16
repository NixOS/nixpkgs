{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "requests-oauth";
  version = "0.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nBsHOJZ+8cD28Osf8JpwAEmc0HpgnqjxdwtRW5U69pI=";
  };

  propagatedBuildInputs = [
    requests
  ];

  doCheck = false; # disabled due to Python 2 tests (?) - missing parenthesis

  meta = {
    description = "Python's Requests OAuth (Open Authentication) plugin";
    homepage = "https://github.com/maraujop/requests-oauth";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kittywitch ];
  };
}
