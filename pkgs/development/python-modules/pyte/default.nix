{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, pytest-runner, wcwidth }:

buildPythonPackage rec {
  pname = "pyte";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e71d03e972d6f262cbe8704ff70039855f05ee6f7ad9d7129df9c977b5a88c5";
  };

  nativeBuildInputs = [ pytest-runner ];

  propagatedBuildInputs = [ wcwidth ];

  checkInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_input_output"
  ];

  meta = with lib; {
    description = "Simple VTXXX-compatible linux terminal emulator";
    homepage = "https://github.com/selectel/pyte";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ flokli ];
  };
}
