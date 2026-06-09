{
  lib,
  aiounittest,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  google-api-core,
  google-cloud-core,
  google-cloud-testutils,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  pyyaml,
  setuptools,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-firestore";
  version = "2.27.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-firestore-v${finalAttrs.version}";
    hash = "sha256-hdUT4SRPOL+ArpU4RcsNCUCV3UCW3vQgwtHuxJiyZeU=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/google-cloud-firestore";

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-cloud-core
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  pythonRelaxDeps = [ "protobuf" ];

  nativeCheckInputs = [
    freezegun
    google-cloud-testutils
    mock
    pytest-asyncio
    pytestCheckHook
    pyyaml
  ]
  ++ lib.optionals (pythonOlder "3.14") [ aiounittest ];

  preCheck = ''
    # do not shadow imports
    rm -r google
  ''
  + lib.optionalString (pythonAtLeast "3.14") ''
    # aiounittest is not available for Python 3.14
    rm -r tests/unit/v1/test_bulk_writer.py
  '';

  disabledTestPaths = [
    # Tests are broken
    "tests/system/test_system.py"
    "tests/system/test_system_async.py"
    # Test requires credentials
    "tests/system/test_pipeline_acceptance.py"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # RuntimeError: There is no current event loop in thread 'MainThread'
    # due to eliding aiounittest
    "tests/unit/v1/test_bundle.py::TestAsyncBundle::test_async_query"
  ];

  pythonImportsCheck = [
    "google.cloud.firestore_v1"
    "google.cloud.firestore_admin_v1"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "google-cloud-firestore-v(.*)"
    ];
  };

  meta = {
    description = "Google Cloud Firestore API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-firestore";
    changelog = "https://github.com/googleapis/google-cloud-python/tree/${finalAttrs.src.tag}/packages/google-cloud-firestore/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
