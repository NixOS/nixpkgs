{ lib
, buildPythonPackage
, fetchPypi
, cython
, hypothesis
, numpy
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "blis";
  version = "0.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fOrEZoAfnZfss04Q3e2MJM9eCSfqfoNNocydLtP8Nm8=";
  };

  postPatch = ''
    # See https://github.com/numpy/numpy/issues/21079
    substituteInPlace blis/benchmark.py \
      --replace "numpy.__config__.blas_ilp64_opt_info" "numpy.__config__.blas_opt_info"
  '';

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    hypothesis
    pytest
  ];

  pythonImportsCheck = [
    "blis"
  ];

  meta = with lib; {
    description = "BLAS-like linear algebra library";
    homepage = "https://github.com/explosion/cython-blis";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    platforms = platforms.x86_64;
  };
}
