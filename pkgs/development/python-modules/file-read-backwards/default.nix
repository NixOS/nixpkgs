{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "file-read-backwards";
  version = "3.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "file_read_backwards";
    inherit version;
    hash = "sha256-VHjTBeuuquj+PGWFok38MmIXAiRFCsyTITmPDSbN0Qk=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "file_read_backwards" ];

  meta = with lib; {
    description = "Memory efficient way of reading files line-by-line from the end of file";
    homepage = "https://github.com/RobinNil/file_read_backwards";
    changelog = "https://github.com/RobinNil/file_read_backwards/blob/v${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ j0hax ];
  };
}
