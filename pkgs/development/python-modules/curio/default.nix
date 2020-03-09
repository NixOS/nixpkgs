{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytest
, sphinx
}:

buildPythonPackage rec {
  pname = "curio";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "51d1a7b49b4f8dd1486ac785c72d522962e93ccfdcfc1f818f5c7553a307b5ef";
  };

  disabled = !isPy3k;

  checkInputs = [ pytest sphinx ];

  __darwinAllowLocalNetworking = true;

  # test_aside_basic times out,
  # test_aside_cancel fails because modifies PYTHONPATH and cant find pytest
  checkPhase = ''
    # __pycache__ was packaged accidentally, https://github.com/dabeaz/curio/issues/301
    rm -r tests/__pycache__
    pytest --deselect tests/test_task.py::test_aside_basic --deselect tests/test_task.py::test_aside_cancel
  '';

  meta = with lib; {
    homepage = "https://github.com/dabeaz/curio";
    description = "Library for performing concurrent I/O with coroutines in Python 3";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
