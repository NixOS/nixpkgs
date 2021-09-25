{ lib
, buildPythonPackage
, fetchPypi
, six
, pytest-runner
, pytest
}:

buildPythonPackage rec {
  pname = "paste";
  version = "3.5.0";

  src = fetchPypi {
    pname = "Paste";
    inherit version;
    sha256 = "17f3zppjjprs2jnklvzkz23mh9jdn6b1f445mvrjdm4ivi15q28v";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest-runner pytest ];

  # Certain tests require network
  checkPhase = ''
    py.test -k "not test_cgiapp and not test_proxy"
  '';

  meta = with lib; {
    description = "Tools for using a Web Server Gateway Interface stack";
    homepage = "http://pythonpaste.org/";
    license = licenses.mit;
  };

}
