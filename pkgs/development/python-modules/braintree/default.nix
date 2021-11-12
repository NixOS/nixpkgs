{ lib,
  fetchPypi,
  requests,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "braintree";
  version = "4.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "946abd50fe2843eec586ac3cec285d27dfae0cc5a43a64b505e8a2800b8a74a6";
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
