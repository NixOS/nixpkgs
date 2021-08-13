{ lib,
  fetchPypi,
  requests,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "braintree";
  version = "4.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "85eacc5a191a8c472744900814c42fdb4677167bb60725a8795518fd501ce7a2";
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
