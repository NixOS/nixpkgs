{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, six
}:

buildPythonPackage rec {
  pname = "paste";
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "062jk0nlxf6lb2wwj6zc20rlvrwsnikpkh90y0dn8cjch93s6ii3";
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
