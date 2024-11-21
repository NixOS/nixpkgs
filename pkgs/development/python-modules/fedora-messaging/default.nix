{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
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
  pytestCheckHook,
  pytest-twisted,
  pytest-mock,
  treq,
}:

buildPythonPackage rec {
  pname = "fedora-messaging";
  version = "3.6.0";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "fedora_messaging";
    inherit version;
    hash = "sha256-7NsiDndNHTf8GZ4uIN1Hv4ZMuxwAjHT/CmkNW75HYJ4=";
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

  nativeCheckInputs = [
    pytestCheckHook
    pytest-twisted
    pytest-mock
    treq
  ];

  pythonImportsCheck = "fedora_messaging";

  meta = with lib; {
    description = "Library for sending AMQP messages with JSON schema in Fedora infrastructure";
    homepage = "https://github.com/fedora-infra/fedora-messaging";
    changelog = "https://github.com/fedora-infra/fedora-messaging/blob/v${version}/docs/changelog.md";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ erictapen ];
  };
}
