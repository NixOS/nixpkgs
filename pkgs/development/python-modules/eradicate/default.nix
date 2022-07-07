{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "eradicate";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "27434596f2c5314cc9b31410c93d8f7e8885747399773cd088d3adea647a60c8";
  };

  meta = with lib; {
    description = "eradicate removes commented-out code from Python files.";
    homepage = "https://github.com/myint/eradicate";
    license = [ licenses.mit ];

    maintainers = [ maintainers.mmlb ];
  };
}
