{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  pythonOlder,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "chardet";
  version = "5.2.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Gztv9HmoxBS8P6LAhSmVaVxKAm3NbQYzst0JLKOcHPc=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTests = [
    # flaky; https://github.com/chardet/chardet/issues/256
    "test_detect_all_and_detect_one_should_agree"
  ];

  pythonImportsCheck = [ "chardet" ];

  meta = with lib; {
    changelog = "https://github.com/chardet/chardet/releases/tag/${version}";
    description = "Universal encoding detector";
    mainProgram = "chardetect";
    homepage = "https://github.com/chardet/chardet";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
  };
}
