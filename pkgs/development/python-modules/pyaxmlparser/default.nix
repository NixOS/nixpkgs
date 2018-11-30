{ buildPythonPackage, stdenv, lxml, click, fetchPypi }:

buildPythonPackage rec {
  version = "0.3.13";
  pname = "pyaxmlparser";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mzdrifnaky57vkmdvg0rgjss55xkxaramci3wpv4h65lmk95988";
  };

  propagatedBuildInputs = [ lxml click ];

  meta = with stdenv.lib; {
    description = "Python3 Parser for Android XML file and get Application Name without using Androguard";
    homepage = https://github.com/appknox/pyaxmlparser;
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
