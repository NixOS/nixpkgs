{ lib, fetchPypi, requests, buildPythonPackage }:

buildPythonPackage rec {
  pname = "braintree";
  version = "4.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de8270c24c4557bcb76d2079bb4cabf380ce467d17c65f10ee5159da7ff8496a";
  };

  propagatedBuildInputs = [ requests ];

  # pypi release does not include tests
  doCheck = false;

  meta = with lib; {
    description = "Python library for integration with Braintree";
    homepage = "https://github.com/braintree/braintree_python";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
