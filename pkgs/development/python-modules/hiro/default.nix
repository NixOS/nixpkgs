{ stdenv, buildPythonPackage, fetchPypi, six, mock }:
buildPythonPackage rec {
  pname = "hiro";
  version = "0.5.1";
  src = fetchPypi {
    inherit pname version;

    sha256 = "d10e3b7f27b36673b4fa1283cd38d610326ba1ff1291260d0275152f15ae4bc7";
  };

  propagatedBuildInputs = [ six mock ];

  meta = with stdenv.lib; {
    description = "Time manipulation utilities for Python";
    homepage = "https://hiro.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ nyarly ];
  };
}
