{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  colcon,
  setuptools,
  argcomplete,
  pytestCheckHook,
  pytest-cov-stub,
}:
buildPythonPackage rec {
  pname = "colcon-argcomplete";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-argcomplete";
    tag = version;
    hash = "sha256-A6ia9OVZa+DwChVwCmkjvDtUloiFQyqtmhlaApbD7iI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colcon
    argcomplete
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  disabledTestPaths = [
    "test/test_flake8.py"
    "test/test_spell_check.py"
  ];

  pythonImportsCheck = [
    "colcon_argcomplete"
  ];

  meta = {
    description = "Extension for colcon-core to provide command line completion using argcomplete";
    homepage = "https://github.com/colcon/colcon-argcomplete";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
