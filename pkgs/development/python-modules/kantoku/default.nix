{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  gevent,
  mock,
  psutil,
  pytest-cov-stub,
  pytestCheckHook,
  pyyaml,
  pyzmq,
  tornado,
}:

buildPythonPackage rec {
  pname = "kantoku";
  version = "0.18.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bentoml";
    repo = "kantoku";
    tag = version;
    hash = "sha256-pI79B7TDZwL4Jz5e7PDPIf8iIGiwCOKFI2jReUt8UNg=";
  };

  build-system = [ flit-core ];

  dependencies = [
    psutil
    pyzmq
    tornado
  ];

  nativeCheckInputs = [
    gevent
    mock
    pytest-cov-stub
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [ "circus" ];

  disabledTests = [
    # AssertionError
    "test_streams"
  ];

  meta = {
    description = "A Process & Socket Manager built with zmq";
    homepage = "https://github.com/bentoml/kantoku";
    changelog = "https://github.com/bentoml/kantoku/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
