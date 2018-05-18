{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "filelock";
  version = "3.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "011327d4ed939693a5b28c0fdf2fd9bda1f68614c1d6d0643a89382ce9843a71";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/benediktschmitt/py-filelock;
    description = "A platform independent file lock for Python";
    license = licenses.unlicense;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
