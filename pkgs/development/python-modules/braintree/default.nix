{ lib,
  fetchPypi,
  requests,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "braintree";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "79ddadaa9db60b81762a10af0c0d994fd60d21616c7d9229d6f7ce1930f8d343";
  };

  propagatedBuildInputs = [ requests ];

  # pypi release does not include tests
  doCheck = false;

  meta = with lib; {
    description = "Python library for integration with Braintree";
    homepage = "https://github.com/braintree/braintree_python";
    license = licenses.mit;
    maintainers = [ maintainers.ivegotasthma ];
  };
}
