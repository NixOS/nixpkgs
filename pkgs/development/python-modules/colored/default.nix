{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "colored";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wlsg7z406q31r5fpwkqfpyfpigazbmq9qm856wfbn861k2773zf";
  };

  # No proper test suite
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://gitlab.com/dslackw/colored;
    description = "Simple library for color and formatting to terminal";
    license = licenses.mit;
  };

}
