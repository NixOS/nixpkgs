{ lib,
  fetchPypi,
  requests,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "braintree";
  version = "3.54.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09dbj04r55hnm8zvfz8wbnxkxb1pfy7g43pzcgs4hhh5xh45ppfd";
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
