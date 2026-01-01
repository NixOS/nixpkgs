{
  lib,
<<<<<<< HEAD
  stdenv,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyzmq,
  setproctitle,
  setuptools,
}:

buildPythonPackage rec {
  pname = "powerapi";
  version = "2.10.0";
  pyproject = true;

<<<<<<< HEAD
=======
  disabled = pythonOlder "3.10";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "powerapi-ng";
    repo = "powerapi";
    tag = "v${version}";
    hash = "sha256-rn1qe0RwYuUR23CgzOOeiwe1wuFihnhQ9a6ALgSP/cQ=";
  };

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "powerapi" ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    "test_puller"
    "TestDispatcher"
    "TestK8sProcessor"
    "TestPusher"
  ];

  meta = {
    description = "Python framework for building software-defined power meters";
    homepage = "https://github.com/powerapi-ng/powerapi";
    changelog = "https://github.com/powerapi-ng/powerapi/releases/tag/${src.tag}";
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "powerapi" ];

  meta = {
    description = "Python framework for building software-defined power meters";
    homepage = "https://github.com/powerapi-ng/powerapi";
    changelog = "https://github.com/powerapi-ng/powerapi/releases/tag/v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
