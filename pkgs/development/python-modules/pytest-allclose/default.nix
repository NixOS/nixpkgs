{ lib
, fetchPypi
, buildPythonPackage
, pytest
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-allclose";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-svDFIfplIoFADUoQXIRFTbPFC5k7z+6YYTgL5pzGsEE=";
  };

  propagatedBuildInputs = [
    numpy
    pytest
  ];

  disabledTests = [
    # AssertionError: assert (0 == 0 and 0 == 1)
    "test_bad_override_parameter"
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_allclose" ];

  meta = with lib; {
    description = "Pytest fixture extending Numpy's allclose function";
    homepage = "https://www.nengo.ai/pytest-allclose";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
