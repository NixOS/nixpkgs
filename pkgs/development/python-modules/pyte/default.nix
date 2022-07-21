{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, pytest-runner, wcwidth }:

buildPythonPackage rec {
  pname = "pyte";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ub/Rt4F1nnVypuVTwBDMk+71ihnY0VkERthMGbGwl7A=";
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
