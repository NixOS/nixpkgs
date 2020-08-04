{ lib,
  fetchPypi,
  requests,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "braintree";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0aw5n1hqrg5pb5xmcr1b8y9i7v8zj23q9k2p4b6bwnq2c2fqi8wr";
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
