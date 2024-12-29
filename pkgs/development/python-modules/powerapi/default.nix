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
  version = "2.9.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "powerapi-ng";
    repo = "powerapi";
    rev = "refs/tags/v${version}";
    hash = "sha256-iFWCrO9frMK68kefmKQrXra1g5efDCj2ZOlVwxDNvXw=";
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
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "powerapi" ];

  meta = {
    description = "Python framework for building software-defined power meters";
    homepage = "https://github.com/powerapi-ng/powerapi";
    changelog = "https://github.com/powerapi-ng/powerapi/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
