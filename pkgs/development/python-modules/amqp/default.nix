{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pytest-rerunfailures,
  setuptools,
  vine,
}:

buildPythonPackage (finalAttrs: {
  pname = "amqp";
  version = "5.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-eanAq3DnF0VmfxJ/+AZmiUpzTCYja28zFJyWSwlvCyA=";
  };

  build-system = [ setuptools ];

  dependencies = [ vine ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-rerunfailures
  ];

  disabledTests = [
    # Requires network access
    "test_rmq.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Requires network access but fails on macos only
    "test_connection.py"
  ];

  pythonImportsCheck = [ "amqp" ];

  meta = {
    description = "Python client for the Advanced Message Queuing Protocol (AMQP). This is a fork of amqplib which is maintained by the Celery project";
    homepage = "https://github.com/celery/py-amqp";
    changelog = "https://github.com/celery/py-amqp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
