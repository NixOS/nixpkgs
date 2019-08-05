{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pytestrunner
, pytest
}:

buildPythonPackage rec {
  pname = "paste";
  version = "3.1.0";

  src = fetchPypi {
    pname = "Paste";
    inherit version;
    sha256 = "1r531zsznwlflhn7pbc7kaagycqxyjlsanjcvy7rkdjsvwi3ychq";
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
