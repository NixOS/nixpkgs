{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  filelock,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  requests,
  setuptools,
  tqdm,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "gdown";
  version = "6.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-NhxuBMbKM131C51x9AvP6atw+yahsOiQpCcmd4E4lVM=";
  };

  build-system = [
    hatchling
    hatch-vcs
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    beautifulsoup4
    filelock
    requests
    setuptools
    tqdm
  ]
  ++ requests.optional-dependencies.socks;

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # requires network
    "tests/test___main__.py"
    "tests/test_cached_download.py"
    "tests/test_download.py"
    "tests/test_download_folder.py"
  ];

  pythonImportsCheck = [ "gdown" ];

  meta = {
    description = "CLI tool for downloading large files from Google Drive";
    homepage = "https://github.com/wkentaro/gdown";
    changelog = "https://github.com/wkentaro/gdown/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ breakds ];
    mainProgram = "gdown";
  };
})
