{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, six
}:

buildPythonPackage rec {
  pname = "paste";
  version = "3.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16500e43f710e93d94a540ee5f0f7743dee1791bdfc1e65d05703a2f13378207";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ six ];

  # Certain tests require network
  checkPhase = ''
    NOSE_EXCLUDE=test_ok,test_form,test_error,test_stderr,test_paste_website nosetests
  '';

  meta = with stdenv.lib; {
    description = "Tools for using a Web Server Gateway Interface stack";
    homepage = http://pythonpaste.org/;
    license = licenses.mit;
  };

}
