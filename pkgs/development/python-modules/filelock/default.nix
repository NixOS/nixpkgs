{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "filelock";
  version = "3.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97694f181bdf58f213cca0a7cb556dc7bf90e2f8eb9aa3151260adac56701afb";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/benediktschmitt/py-filelock;
    description = "A platform independent file lock for Python";
    license = licenses.unlicense;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
