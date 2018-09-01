{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "filelock";
  version = "3.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "59ccab92fe118da7e5ce5a9fcd95506ade58d9d5f606db4922192524edfac820";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/benediktschmitt/py-filelock;
    description = "A platform independent file lock for Python";
    license = licenses.unlicense;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
