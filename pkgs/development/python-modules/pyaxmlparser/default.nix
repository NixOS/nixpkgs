{ buildPythonPackage, stdenv, lxml, click, fetchPypi }:

buildPythonPackage rec {
  version = "0.3.9";
  pname = "pyaxmlparser";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af714d8adafcea776dd14cbd6d09f5d6d278f7ba333f540dde3b4c34f5f04784";
  };

  propagatedBuildInputs = [ lxml click ];

  meta = with stdenv.lib; {
    description = "Python3 Parser for Android XML file and get Application Name without using Androguard";
    homepage = https://github.com/appknox/pyaxmlparser;
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
