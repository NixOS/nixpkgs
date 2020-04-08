{ lib,
  fetchPypi,
  requests,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "braintree";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m8z0ig40xmgcnmf508nflyy1w4qmff4kqxarrpg7rvsfj4pjsmh";
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
