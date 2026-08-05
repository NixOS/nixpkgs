{
  lib,
  stdenv,
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
  pythonAtLeast,
  pythonOlder,
  pyzmq,
  setproctitle,
  setuptools,
}:

buildPythonPackage rec {
  pname = "powerapi";
  version = "2.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "powerapi-ng";
    repo = "powerapi";
    tag = "v${version}";
    hash = "sha256-rn1qe0RwYuUR23CgzOOeiwe1wuFihnhQ9a6ALgSP/cQ=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  dependencies = [
    pyzmq
    setproctitle
  ];

  optional-dependencies = {
    kubernetes = [ kubernetes ];
    mongodb = [ pymongo ];
    # opentsdb = [ opentsdb-py ];
    prometheus = [ prometheus-client ];
  }
  // lib.optionalAttrs (pythonOlder "3.14") {
    # influxdb-client depends on reactivex, which is disabled on 3.14
    influxdb = [ influxdb-client ];
  };

  nativeCheckInputs = [
    mock
    pytest-cov-stub
    pytestCheckHook
    pytest-timeout
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "powerapi" ];

  # multiprocessing pickling fails: darwin sandbox + py3.14 weakref change
  disabledTests = lib.optionals (stdenv.hostPlatform.isDarwin || pythonAtLeast "3.14") [
    "test_puller"
    "TestDispatcher"
    "TestK8sProcessor"
    "TestPusher"
  ];

  meta = {
    description = "Python framework for building software-defined power meters";
    homepage = "https://github.com/powerapi-ng/powerapi";
    changelog = "https://github.com/powerapi-ng/powerapi/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
