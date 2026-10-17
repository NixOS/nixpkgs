{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "file-read-backwards";
  version = "3.2.0";
  pyproject = true;

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

  meta = {
    description = "Memory efficient way of reading files line-by-line from the end of file";
    homepage = "https://github.com/RobinNil/file_read_backwards";
    changelog = "https://github.com/RobinNil/file_read_backwards/blob/v${version}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ j0hax ];
  };
}
