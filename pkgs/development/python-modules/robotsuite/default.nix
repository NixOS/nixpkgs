{ stdenv, buildPythonPackage, fetchPypi, unittest2, robotframework, lxml }:

buildPythonPackage rec {
  pname = "robotsuite";
  version = "2.0.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15iw7g6gspf1ill0mzjrj71dirqfc86f1j14wphdvs2lazv8d50z";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ robotframework lxml ];

  meta = with stdenv.lib; {
    description = "Python unittest test suite for Robot Framework";
    homepage = http://github.com/collective/robotsuite/;
    license = licenses.gpl3;
  };
}
