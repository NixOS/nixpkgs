{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pytestrunner
, pytest
}:

buildPythonPackage rec {
  pname = "paste";
  version = "3.0.5";

  src = fetchPypi {
    pname = "Paste";
    inherit version;
    sha256 = "1bb2068807ce3592d313ce9b1a25a7ac842a504e7e3b005027193d17a043d1a8";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestrunner pytest ];

  # Certain tests require network
  checkPhase = ''
    py.test -k "not test_cgiapp and not test_proxy"
  '';

  meta = with stdenv.lib; {
    description = "Tools for using a Web Server Gateway Interface stack";
    homepage = http://pythonpaste.org/;
    license = licenses.mit;
  };

}
