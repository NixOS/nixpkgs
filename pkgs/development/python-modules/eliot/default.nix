{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,
  versioneer,

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

buildPythonPackage (finalAttrs: {
  pname = "eliot";
  version = "1.18.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "itamarst";
    repo = "eliot";
    tag = finalAttrs.version;
    hash = "sha256-YUvHdnpWtsy2NlrVLaaewcUPKGLfdfX/zvowV0jcXuw=";
  };

  build-system = [
    setuptools
    setuptools-scm
    versioneer
  ];

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
    changelog = "https://github.com/itamarst/eliot/blob/${finalAttrs.version}/docs/source/news.rst";
    mainProgram = "eliot-prettyprint";
    license = lib.licenses.asl20;
  };
})
