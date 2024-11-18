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
  version = "1.15.0";
  pyproject = true;

  disabled = pythonOlder "3.8" || pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "itamarst";
    repo = "eliot";
    rev = "refs/tags/${version}";
    hash = "sha256-Ur7q7PZ5HH4ttD3b0HyBTe1B7eQ2nEWcTBR/Hjeg9yw=";
  };

  patches = [
    (fetchpatch2 {
      name = "numpy2-compat.patch";
      url = "https://github.com/itamarst/eliot/commit/39eccdad44f91971ecf1211fb01366b4d9801817.patch";
      hash = "sha256-al6olmvFZ8pDblljWmWqs5QrtcuHKcea255XgG+1+1o=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    boltons
    orjson
    pyrsistent
    zope-interface
  ];

  nativeCheckInputs = [
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

  # Tests run eliot-prettyprint in out/bin.
  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  meta = {
    homepage = "https://eliot.readthedocs.io";
    description = "Logging library that tells you why it happened";
    changelog = "https://github.com/itamarst/eliot/blob/${version}/docs/source/news.rst";
    mainProgram = "eliot-prettyprint";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dpausp ];
  };
}
