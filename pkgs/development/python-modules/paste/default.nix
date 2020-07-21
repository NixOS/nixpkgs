{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pytestrunner
, pytest
}:

buildPythonPackage rec {
  pname = "paste";
  version = "3.4.1";

  src = fetchPypi {
    pname = "Paste";
    inherit version;
    sha256 = "1csqn7g9b05hp3fgd82355k4pb5rv12k9x6p2mdw2v01m385171p";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestrunner pytest ];

  # Certain tests require network
  checkPhase = ''
    py.test -k "not test_cgiapp and not test_proxy"
  '';

  meta = with stdenv.lib; {
    description = "Tools for using a Web Server Gateway Interface stack";
    homepage = "http://pythonpaste.org/";
    license = licenses.mit;
  };

}
