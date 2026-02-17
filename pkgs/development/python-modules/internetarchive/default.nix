{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  jsonpatch,
  schema,
  responses,
  setuptools,
  tqdm,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "internetarchive";
  version = "5.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jjjake";
    repo = "internetarchive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eBTUKJs3j8LmQJSIBKAlDOjUglLHrjwtGx5O9Wn5C8Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    tqdm
    requests
    jsonpatch
    schema
    urllib3
  ];

  nativeCheckInputs = [
    responses
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require network access
    "test_get_item_with_kwargs"
    "test_upload"
    "test_upload_metadata"
    "test_upload_queue_derive"
    "test_upload_validate_identifie"
    "test_upload_validate_identifier"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/cli/test_ia.py"
    "tests/cli/test_ia_download.py"
  ];

  pythonImportsCheck = [ "internetarchive" ];

  meta = {
    description = "Python and Command-Line Interface to Archive.org";
    homepage = "https://github.com/jjjake/internetarchive";
    changelog = "https://github.com/jjjake/internetarchive/blob/${finalAttrs.src.tag}/HISTORY.rst";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "ia";
  };
})
