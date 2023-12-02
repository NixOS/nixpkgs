{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pylsqpack";
  version = "0.3.18";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ra5V5yGHdQX01czUlZHWk1PypUioZz36+yUdOFs8CX8=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pylsqpack" ];

  meta = with lib; {
    description = "Python wrapper for the ls-qpack QPACK library";
    homepage = "https://github.com/aiortc/pylsqpack";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
