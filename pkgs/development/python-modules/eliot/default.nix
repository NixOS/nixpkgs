{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  boltons,
  orjson,
  pyrsistent,
  zope-interface,

  # tests
  addBinToPathHook,
  dask,
  distributed,
  hypothesis,
  pandas,
  pytestCheckHook,
  testtools,
  twisted,
  daemontools,
}:

buildPythonPackage rec {
  pname = "eliot";
  version = "1.17.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "itamarst";
    repo = "eliot";
    tag = version;
    hash = "sha256-x6zonKL6Ys1fyUjyOgVgucAN64Dt6dCzdBrxRZa+VDQ=";
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ daemontools ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "eliot" ];

  meta = {
    description = "Logging library that tells you why it happened";
    homepage = "https://eliot.readthedocs.io";
    changelog = "https://github.com/itamarst/eliot/blob/${version}/docs/source/news.rst";
    mainProgram = "eliot-prettyprint";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dpausp ];
  };
}
