{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  nix-update-script,

  # build-system
  poetry-core,
  poetry-dynamic-versioning,

  # dependencies
  click,
  cryptography,
  dnspython,
  httpx,
  libipld,
  pydantic,
  typing-extensions,
  websockets,

  # nativeCheckInputs
  pytestCheckHook,
  pytest-asyncio,
<<<<<<< HEAD
=======
  coverage,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "atproto";
<<<<<<< HEAD
  version = "0.0.65";
=======
  version = "0.0.62";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "pyproject";

  # use GitHub, pypi does not include tests
  src = fetchFromGitHub {
    owner = "MarshalX";
    repo = "atproto";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-0NogKxYO+lCtNhK2ZWwRLQTV7rHU5Oz+lnE4awsoPsM=";
=======
    hash = "sha256-T1Jdg62fSV+5qC486Agsuk6qrDhGSNHq75uvOyvOwpA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  POETRY_DYNAMIC_VERSIONING_BYPASS = version;

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    click
    cryptography
    dnspython
    httpx
    libipld
    pydantic
    typing-extensions
    websockets
  ];

  pythonRelaxDeps = [
    "cryptography"
    "websockets"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
<<<<<<< HEAD
=======
    coverage
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  disabledTestPaths = [
    # the required `_PATH_TO_LEXICONS` is outside the package tree
    "tests/test_atproto_lexicon/test_lexicon_parser.py"
    # touches network
    "tests/test_atproto_identity/test_atproto_data.py"
    "tests/test_atproto_identity/test_async_atproto_data.py"
    "tests/test_atproto_identity/test_did_resolver.py"
    "tests/test_atproto_identity/test_async_did_resolver.py"
    "tests/test_atproto_identity/test_did_resolver_cache.py"
    "tests/test_atproto_identity/test_async_did_resolver_cache.py"
    "tests/test_atproto_identity/test_handle_resolver.py"
    "tests/test_atproto_identity/test_async_handle_resolver.py"
    "tests/test_atproto_server/auth/test_custom_feed_auth.py"
  ];

  pythonImportsCheck = [
    "atproto"
    "atproto_cli"
    "atproto_client"
    "atproto_codegen"
    "atproto_core"
    "atproto_crypto"
    "atproto_firehose"
    "atproto_identity"
    "atproto_lexicon"
    "atproto_server"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AT Protocol (Bluesky) SDK for Python";
    homepage = "https://github.com/MarshalX/atproto";
    changelog = "https://github.com/MarshalX/atproto/blob/v${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vji ];
  };
}
