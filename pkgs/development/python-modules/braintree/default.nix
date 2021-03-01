{ lib,
  fetchPypi,
  requests,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "braintree";
  version = "4.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef19892f99fa497c90684db6d41442e94b2d3b0ed00afe2c574e46d89cb9a89c";
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
