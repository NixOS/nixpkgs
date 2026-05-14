{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  flake8,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flake8-deprecated";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gforcada";
    repo = "flake8-deprecated";
    tag = version;
    hash = "sha256-KF0hWhMZEWuSPUyfStayNa5Nfss9NpTvMXPeemWbQXU=";
  };

  build-system = [ hatchling ];

  dependencies = [ flake8 ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "run_tests.py" ];

  pythonImportsCheck = [ "flake8_deprecated" ];

  meta = {
    changelog = "https://github.com/gforcada/flake8-deprecated/blob/${src.tag}/CHANGES.rst";
    description = "Flake8 plugin that warns about deprecated method calls";
    homepage = "https://github.com/gforcada/flake8-deprecated";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lopsided98 ];
  };
}
