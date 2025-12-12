{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  influxdb-client,
  kubernetes,
  mock,
  prometheus-client,
  pymongo,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  pyzmq,
  setproctitle,
  setuptools,
}:

buildPythonPackage rec {
  pname = "powerapi";
  version = "2.10.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "powerapi-ng";
    repo = "powerapi";
    tag = "v${version}";
    hash = "sha256-rn1qe0RwYuUR23CgzOOeiwe1wuFihnhQ9a6ALgSP/cQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyzmq
    setproctitle
  ];

  optional-dependencies = {
    influxdb = [ influxdb-client ];
    kubernetes = [ kubernetes ];
    mongodb = [ pymongo ];
    # opentsdb = [ opentsdb-py ];
    prometheus = [ prometheus-client ];
  };

  nativeCheckInputs = [
    mock
    pytest-cov-stub
    pytestCheckHook
    pytest-timeout
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "powerapi" ];

  meta = {
    description = "Python framework for building software-defined power meters";
    homepage = "https://github.com/powerapi-ng/powerapi";
    changelog = "https://github.com/powerapi-ng/powerapi/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
