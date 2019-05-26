{ lib,
  fetchPypi,
  requests,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "braintree";
  version = "3.53.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "026apwkjn83la7jm0azz3qajg26nza3gh49zd37j0rsp6cgmfa24";
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
