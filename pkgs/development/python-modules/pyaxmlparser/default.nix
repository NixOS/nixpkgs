{ buildPythonPackage, stdenv, lxml, click, fetchPypi }:

buildPythonPackage rec {
  version = "0.3.7";
  pname = "pyaxmlparser";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1spwr28sc6fc3cqdx2j2zq38qx889hixl4ahhf1nphpmrl39ypxr";
  };

  propagatedBuildInputs = [ lxml click ];

  meta = with stdenv.lib; {
    description = "Python3 Parser for Android XML file and get Application Name without using Androguard";
    homepage = https://github.com/appknox/pyaxmlparser;
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
