{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  umodbus,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysolarmanv5";
  version = "3.0.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jmccrohan";
    repo = "pysolarmanv5";
    tag = "v${version}";
    hash = "sha256-ENEXuMQGQ1Jwgpfp2v0T2dveTJoIaVu+DfefQZy8ntE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    umodbus
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pysolarmanv5" ];

  meta = {
    description = "Python module to interact with Solarman Data Logging Sticks";
    changelog = "https://github.com/jmccrohan/pysolarmanv5/blob/${src.tag}/CHANGELOG.md";
    homepage = "https://github.com/jmccrohan/pysolarmanv5";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Scrumplex ];
  };
}
