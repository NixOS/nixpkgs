{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,
  pythonRelaxDepsHook,

  # dependencies
  blinker,
  click,
  crochet,
  jsonschema,
  pika,
  pyopenssl,
  requests,
  service-identity,
  tomli,
  twisted,

  # tests
  pytest-mock,
  pytest-twisted,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fedora-messaging";
  version = "3.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fedora-infra";
    repo = "fedora-messaging";
    tag = "v${version}";
    hash = "sha256-384pvF/MgOReA52bfifa4Fuo79b9zUe+AK7vfIkFSf8=";
  };

  build-system = [ poetry-core ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    # python3.14-fedora-messaging> packaging._tokenizer.ParserSyntaxError: Expected matching RIGHT_PARENTHESIS for LEFT_PARENTHESIS, after version specifier
    # python3.14-fedora-messaging>     jsonschema (>=3.2.0,<4.0.0 || >=4.0.0,<5.0.0)
    # python3.14-fedora-messaging>                ~~~~~~~~~~~~~~~~^
    "jsonschema"
  ];

  dependencies = [
    blinker
    click
    crochet
    jsonschema
    pika
    pyopenssl
    requests
    service-identity
    tomli
    twisted
  ];

  pythonImportsCheck = [ "fedora_messaging" ];

  nativeCheckInputs = [
    pytest-mock
    pytest-twisted
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/unit" ];

  disabledTests = [
    # Broken since click was updated to 8.2.1 in https://github.com/NixOS/nixpkgs/pull/448189
    # AssertionError
    "test_no_conf"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AttributeError: module 'errno' has no attribute 'EREMOTEIO'. Did you mean: 'EREMOTE'?
    "test_publish_rejected_message"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Library for sending AMQP messages with JSON schema in Fedora infrastructure";
    homepage = "https://github.com/fedora-infra/fedora-messaging";
    changelog = "https://github.com/fedora-infra/fedora-messaging/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
