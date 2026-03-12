{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-fsutil";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fabiocaccamo";
    repo = "python-fsutil";
    tag = finalAttrs.version;
    hash = "sha256-1XYyfBuaUED+xnVrILEtB+fUpc8sk4BDzGp8Hln/rlc=";
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

  meta = {
    description = "Module with file-system utilities";
    homepage = "https://github.com/fabiocaccamo/python-fsutil";
    changelog = "https://github.com/fabiocaccamo/python-fsutil/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
