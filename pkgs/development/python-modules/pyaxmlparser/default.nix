{ buildPythonPackage, stdenv, lxml, click, fetchPypi }:

buildPythonPackage rec {
  version = "0.3.11";
  pname = "pyaxmlparser";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dbe5ca9ddcf2f5041f6e5e3acc81d2940c696db89de4f840535a256e78f5e489";
  };

  propagatedBuildInputs = [ lxml click ];

  meta = with stdenv.lib; {
    description = "Python3 Parser for Android XML file and get Application Name without using Androguard";
    homepage = https://github.com/appknox/pyaxmlparser;
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
