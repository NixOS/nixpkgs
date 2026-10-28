{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  colcon,
  pylint,
  pytestCheckHook,
  pytest-cov-stub,
  scspell,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "colcon-library-path";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-library-path";
    tag = version;
    hash = "sha256-/Zb8F/WcwpFMeJNLaf69ozXX8f+9gb+WXBda+nc/7MM=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    colcon
  ];

  nativeCheckInputs = [
    pylint
    pytest-cov-stub
    pytestCheckHook
    scspell
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "colcon_library_path"
  ];

  disabledTestPaths = [
    "test/test_flake8.py"
  ];

  meta = {
    description = "Extension for colcon to set the library path environment variable";
    homepage = "https://github.com/colcon/colcon-library-path";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
