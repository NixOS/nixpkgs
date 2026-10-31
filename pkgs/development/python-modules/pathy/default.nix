{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  mock,
  google-cloud-storage,
  pathlib-abc,
  azure-storage-blob,
  boto3,
  pytestCheckHook,
  smart-open,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "pathy";
  version = "0.14.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-GOW+uudNalbgnq0a3JLYeUweejP0VBHAgPef8qTDH64=";
  };

  pythonRelaxDeps = [ "smart-open" ];

  build-system = [ hatchling ];

  dependencies = [
    pathlib-abc
    smart-open
  ];

  optional-dependencies = {
    cli = [ typer ];
    gcs = [ google-cloud-storage ];
    s3 = [ boto3 ];
    azure = [ azure-storage-blob ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  disabledTestPaths = [
    # Exclude tests that require provider credentials
    "pathy/_tests/test_clients.py"
    "pathy/_tests/test_gcs.py"
    "pathy/_tests/test_s3.py"
  ];

  pythonImportsCheck = [ "pathy" ];

  meta = {
    description = "Path interface for local and cloud bucket storage";
    homepage = "https://github.com/justindujardin/pathy";
    changelog = "https://github.com/justindujardin/pathy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "pathy";
  };
})
