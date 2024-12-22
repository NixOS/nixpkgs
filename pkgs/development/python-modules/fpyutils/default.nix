{
  lib,
  atomicwrites,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fpyutils";
  version = "4.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "frnmst";
    repo = "fpyutils";
    rev = "refs/tags/${version}";
    hash = "sha256-VVR1zsejO6kHlMjqqlftDKu3/SyDzgPov9f48HYL/Bk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    atomicwrites
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "fpyutils/tests/*.py" ];

  disabledTests = [
    # Don't run test which requires bash
    "test_execute_command_live_output"
  ];

  pythonImportsCheck = [ "fpyutils" ];

  meta = with lib; {
    description = "Collection of useful non-standard Python functions";
    homepage = "https://github.com/frnmst/fpyutils";
    changelog = "https://blog.franco.net.eu.org/software/fpyutils-${version}/release.html";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
