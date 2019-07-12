{ lib
, buildPythonPackage
, fetchPypi
, numpy
, setuptools
, blas
, isPy27
}:

buildPythonPackage rec {
  pname = "pysparse";
  version = "1.1.1-dev";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nwzgqif9qy1kbjhnrpjjxg5dq75dr0z4hg2haqj2vl5p0z074f2";
  };

  hardeningDisable = [ "all" ];

  propagatedBuildInputs = [
    numpy
    blas
  ];

  meta = with lib; {
    homepage = https://github.com/PythonOptimizers/pysparse;
    description = "A Sparse Matrix Library for Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
