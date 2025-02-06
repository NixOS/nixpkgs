{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  pythonOlder,
  pythonAtLeast,

  setuptools,

  boltons,
  orjson,
  pyrsistent,
  zope-interface,

  daemontools,
  addBinToPathHook,
  dask,
  distributed,
  hypothesis,
  pandas,
  pytestCheckHook,
  testtools,
  twisted,
}:

buildPythonPackage rec {
  pname = "eliot";
  version = "1.16.0";
  pyproject = true;

  disabled = pythonOlder "3.8" || pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "itamarst";
    repo = "eliot";
    tag = version;
    hash = "sha256-KqAXOMrRawzjpt5do2KdqpMMgpBtxeZ+X+th0WwBl+U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    boltons
    orjson
    pyrsistent
    zope-interface
  ];

  nativeCheckInputs = [
    addBinToPathHook
    dask
    distributed
    hypothesis
    pandas
    pytestCheckHook
    testtools
    twisted
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ daemontools ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "eliot" ];

  disabledTests = [
    # Fails since dask's bump to 2024.12.2
    # Reported upstream: https://github.com/itamarst/eliot/issues/507
    "test_compute_logging"
    "test_future"
    "test_persist_logging"
  ];

  meta = {
    homepage = "https://eliot.readthedocs.io";
    description = "Logging library that tells you why it happened";
    changelog = "https://github.com/itamarst/eliot/blob/${version}/docs/source/news.rst";
    mainProgram = "eliot-prettyprint";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dpausp ];
  };
}
