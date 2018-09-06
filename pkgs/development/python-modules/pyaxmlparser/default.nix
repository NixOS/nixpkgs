{ buildPythonPackage, stdenv, lxml, click, fetchPypi }:

buildPythonPackage rec {
  version = "0.3.10";
  pname = "pyaxmlparser";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c1f569f4dc2232d7f146eb190bc513373ff6555f97ae904740f966f0fb2dd77";
  };

  propagatedBuildInputs = [ lxml click ];

  meta = with stdenv.lib; {
    description = "Python3 Parser for Android XML file and get Application Name without using Androguard";
    homepage = https://github.com/appknox/pyaxmlparser;
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
