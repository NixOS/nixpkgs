{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "filelock";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3ad481724adfb2280773edd95ce501e497e88fa4489c6e41e637ab3fd9a456c";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/benediktschmitt/py-filelock;
    description = "A platform independent file lock for Python";
    license = licenses.unlicense;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
