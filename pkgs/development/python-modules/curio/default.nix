{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytest
, sphinx
}:

buildPythonPackage rec {
  pname = "curio";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90f320fafb3f5b791f25ffafa7b561cc980376de173afd575a2114380de7939b";
  };

  disabled = !isPy3k;

  checkInputs = [ pytest sphinx ];

  __darwinAllowLocalNetworking = true;

  # test_aside_basic times out,
  # test_aside_cancel fails because modifies PYTHONPATH and cant find pytest
  checkPhase = ''
    pytest --deselect tests/test_task.py::test_aside_basic --deselect tests/test_task.py::test_aside_cancel -k "not test_ssl_outgoing"
  '';

  meta = with lib; {
    homepage = "https://github.com/dabeaz/curio";
    description = "Library for performing concurrent I/O with coroutines in Python 3";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
