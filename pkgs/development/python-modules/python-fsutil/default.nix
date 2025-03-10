{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-fsutil";
  version = "0.15.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "fabiocaccamo";
    repo = "python-fsutil";
    tag = version;
    hash = "sha256-hzPNj6hqNCnMx1iRK1c6Y70dUU/H4u6o+waEgOhyhuA=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Tests require network access
    "test_download_file"
    "test_read_file_from_url"
  ];

  pythonImportsCheck = [ "fsutil" ];

  meta = with lib; {
    description = "Module with file-system utilities";
    homepage = "https://github.com/fabiocaccamo/python-fsutil";
    changelog = "https://github.com/fabiocaccamo/python-fsutil/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
