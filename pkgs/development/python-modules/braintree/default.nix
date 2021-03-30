{ lib,
  fetchPypi,
  requests,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "braintree";
  version = "4.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25a95f95acb7f180b37f8dcf4df7efa84ae0ba6ad9dc4ba0e724e2cc534c3483";
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
