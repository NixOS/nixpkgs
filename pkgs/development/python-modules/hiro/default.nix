{ stdenv, buildPythonPackage, fetchPypi, six, mock }:
buildPythonPackage rec {
  pname = "hiro";
  version = "0.1.9";
  src = fetchPypi {
    inherit pname version;

    sha256 = "3b19abd8873880ad59575788279731c07838e803c4f31d62410920fa6b1f95d5";
  };

  propagatedBuildInputs = [ six mock ];

  meta = with stdenv.lib; {
    description = "Time manipulation utilities for Python";
    homepage = http://hiro.readthedocs.io/en/latest/;
    license = licenses.mit;
    maintainers = with maintainers; [ nyarly ];
  };
}
