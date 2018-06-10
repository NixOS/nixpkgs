{ stdenv, buildPythonPackage, fetchPypi, six, mock }:
buildPythonPackage rec {
  pname = "hiro";
  version = "0.1.4";
  src = fetchPypi {
    inherit pname version;

    sha256 = "1340lhg7k522bqpz5iakl51qb47mjw804mfwwzm77i7qcm5cwiz8";
  };

  propagatedBuildInputs = [ six mock ];

  meta = with stdenv.lib; {
    description = "Time manipulation utilities for Python";
    homepage = http://hiro.readthedocs.io/en/latest/;
    license = licenses.mit;
    maintainers = with maintainers; [ nyarly ];
  };
}
