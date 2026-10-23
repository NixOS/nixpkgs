{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools_80,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "morfessor";
  version = "2.0.6";
  pyproject = true;

  src = fetchPypi {
    pname = "Morfessor";
    inherit version;
    hash = "sha256-uzvqwjQ0FyTF9kD2WAMHH2I3OlDbqFTVo5hWf5rvurI=";
  };

  build-system = [ setuptools_80 ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [
    "morfessor/test/*"
  ];

  pythonImportsCheck = [ "morfessor" ];

  meta = {
    description = "Tool for unsupervised and semi-supervised morphological segmentation";
    homepage = "https://github.com/aalto-speech/morfessor";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ misuzu ];
  };
}
