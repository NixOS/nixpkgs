{ lib,
  fetchPypi,
  requests,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "braintree";
  version = "3.56.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d1xv7b4s68yfa3snnvcjldj0q7v1izpyvqkv2c1k0w73hl657b5";
  };

  propagatedBuildInputs = [ requests ];

  # pypi release does not include tests
  doCheck = false;

  meta = with lib; {
    description = "Python library for integration with Braintree";
    homepage = https://github.com/braintree/braintree_python;
    license = licenses.mit;
    maintainers = [ maintainers.ivegotasthma ];
  };
}
