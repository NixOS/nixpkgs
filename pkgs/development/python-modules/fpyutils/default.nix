{
  lib,
  atomicwrites,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fpyutils";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frnmst";
    repo = "fpyutils";
    tag = version;
    hash = "sha256-VVR1zsejO6kHlMjqqlftDKu3/SyDzgPov9f48HYL/Bk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    atomicwrites
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "fpyutils/tests/*.py" ];

  disabledTests = [
    # Don't run test which requires bash
    "test_execute_command_live_output"
  ];

  pythonImportsCheck = [ "fpyutils" ];

  meta = {
    description = "Collection of useful non-standard Python functions";
    homepage = "https://github.com/frnmst/fpyutils";
    changelog = "https://blog.franco.net.eu.org/software/fpyutils-${version}/release.html";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
