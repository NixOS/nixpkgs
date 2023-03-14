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
  # Do not update to BLIS 0.9.x until the following issue is resolved:
  # https://github.com/explosion/thinc/issues/771#issuecomment-1255825935
  version = "0.7.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ke9MJQB3hakP/C8Ks9O9O3XNLXhWqaSCt9DayNURoJ0=";
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
  };
}
