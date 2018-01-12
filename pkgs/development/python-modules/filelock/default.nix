{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "filelock";
  version = "2.0.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee355eb66e4c2e5d95689e1253515aad5b3177c274abdd00a57d5ab1aa6d071a";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/benediktschmitt/py-filelock;
    description = "A platform independent file lock for Python";
    license = licenses.unlicense;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
