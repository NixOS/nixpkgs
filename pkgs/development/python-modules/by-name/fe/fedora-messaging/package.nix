{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

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
  version = "3.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fedora-infra";
    repo = "fedora-messaging";
    tag = "v${version}";
    hash = "sha256-eQ0grcp/Cd9yKNbeUtftSmqv3uwOJCh36E6CC1Si1aY=";
  };

  build-system = [ poetry-core ];

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
