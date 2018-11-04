{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, six
}:

buildPythonPackage rec {
  pname = "paste";
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "96b06ff055c4f22a4e5c164551179ed1fa8263bc3ce69b4347c617cd0fcf51f4";
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
