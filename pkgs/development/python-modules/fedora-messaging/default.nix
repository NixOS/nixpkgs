{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
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
  pytest-mock,
  pytest-twisted,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fedora-messaging";
  version = "3.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fedora-infra";
    repo = "fedora-messaging";
    tag = "v${version}";
    hash = "sha256-2EWeJddhD6tV5jRyr3pvWYQBfq6nq0GxeTgL6MRf/jE=";
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

  meta = {
    description = "Library for sending AMQP messages with JSON schema in Fedora infrastructure";
    homepage = "https://github.com/fedora-infra/fedora-messaging";
    changelog = "https://github.com/fedora-infra/fedora-messaging/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
