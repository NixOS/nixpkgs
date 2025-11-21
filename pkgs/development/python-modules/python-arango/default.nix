{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  urllib3,
  requests,
  requests-toolbelt,
  pyjwt,
  importlib-metadata,
  packaging,

  # tests
  mock,
}:

let
  testDBOpts = {
    host = "127.0.0.1";
    port = "8529";
    password = "test";
    secret = "secret";
  };
in

buildPythonPackage rec {
  pname = "python-arango";
  version = "8.2.4";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "arangodb";
    repo = "python-arango";
    tag = version;
    hash = "sha256-xkUUpkkRBIcEjE4mETEtADL8rGUcf4n3cSxqaykF3v8=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    importlib-metadata
    requests
    requests-toolbelt
    packaging
    pyjwt
    setuptools
    urllib3
  ];

  nativeCheckInputs = [
    #arangodb
    mock
    pytestCheckHook
  ];

  # ArangoDB has been removed from Nixpkgs due to lack of maintenace,
  # so we cannot run the tests at present.
  #
  # Before that, the issue was:
  #
  # arangodb is compiled only for particular target architectures
  # (i.e. "haswell"). Thus, these tests may not pass reproducibly,
  # failing with: `166: Illegal instruction` if not run on arangodb's
  # specified architecture.
  #
  # nonetheless, the client library should remain in nixpkgs - since
  # the client library will talk to arangodb across the network and
  # architecture issues will be irrelevant.
  doCheck = false;

  #preCheck = lib.optionalString doCheck ''
  #  # Start test DB
  #  mkdir -p .nix-test/{data,work}
  #
  #  ICU_DATA=${arangodb}/share/arangodb3 \
  #  GLIBCXX_FORCE_NEW=1 \
  #  TZ=UTC \
  #  TZ_DATA=${arangodb}/share/arangodb3/tzdata \
  #  ARANGO_ROOT_PASSWORD=${testDBOpts.password} \
  #  ${arangodb}/bin/arangod \
  #    --server.uid=$(id -u) \
  #    --server.gid=$(id -g) \
  #    --server.authentication=true \
  #    --server.endpoint=http+tcp://${testDBOpts.host}:${testDBOpts.port} \
  #    --server.descriptors-minimum=4096 \
  #    --server.jwt-secret=${testDBOpts.secret} \
  #    --javascript.app-path=.nix-test/app \
  #    --log.file=.nix-test/log \
  #    --database.directory=.nix-test/data \
  #    --foxx.api=false &
  #'';

  pytestFlags = [
    "--host=${testDBOpts.host}"
    "--port=${testDBOpts.port}"
    "--passwd=${testDBOpts.password}"
    "--secret=${testDBOpts.secret}"
  ];

  disabledTests = [
    # AssertionError geo-related - try enabling later
    "test_document_find_in_box"

    # maybe arangod misconfig - try enabling later
    # arango.exceptions.JWTAuthError: [HTTP 401][ERR 401] Wrong credentials
    "test_auth_jwt"

    # ValueError - try enabling later
    # maybe missed 3.9.3->3.10.0 changes
    # most caused by key change: isNewlyCreated->new
    "test_add_hash_index"
    "test_add_skiplist_index"
    "test_add_persistent_index"
    "test_add_ttl_index"
    "test_delete_index"
    "test_pregel_management"

    # formatting error - try enabling later
    # maybe missed 3.9.3->3.10.0 changes
    # caused by: body["computedValues"] = None
    "test_permission_management"
    "test_collection_misc_methods"
    "test_collection_management"
    "test_replication_inventory"

    # want outgoing network to update foxx apis
    # so foxx.api disabled in arangod startup
    "test_foxx_service_management_file"
    "test_foxx_service_management_json"
    "test_foxx_config_management"
    "test_foxx_dependency_management"
    "test_foxx_development_toggle"
    "test_foxx_misc_functions"

    # no replication configured via arangod invocation
    "test_replication_applier"
  ];

  pythonImportsCheck = [ "arango" ];

  meta = {
    description = "Python Driver for ArangoDB";
    homepage = "https://github.com/ArangoDB-Community/python-arango";
    changelog = "https://github.com/ArangoDB-Community/python-arango/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jsoo1 ];
  };
}
