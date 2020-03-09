{ lib,
  fetchPypi,
  requests,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "braintree";
  version = "3.59.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08g8qlnsp9wd2zbf6x3npp1425g7ih4lyljzvybd3vazsbqlw4yq";
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
