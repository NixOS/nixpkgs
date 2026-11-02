{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # optional-dependencies
  furo,
  myst-parser,
  sphinx,
  sphinxHook,

  # tests
  pytest-asyncio_0,
  pytest-cov-stub,
  pytest9_1CheckHook,
}:

buildPythonPackage rec {
  pname = "aiohappyeyeballs";
  version = "2.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiohappyeyeballs";
    tag = "v${version}";
    hash = "sha256-smpdmmut4wYekVew13KZXluI71lSUdZriPejUumkLNU=";
  };

  outputs = [
    "out"
    "doc"
  ];

  build-system = [ poetry-core ] ++ optional-dependencies.docs;

  optional-dependencies = {
    docs = [
      furo
      myst-parser
      sphinx
      sphinxHook
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio_0
    pytest-cov-stub
    # AttributeError: 'FixtureManager' object has no attribute '_arg2fixturedefs'. Did you mean: '_arg2node2fixturedefs'?
    pytest9_1CheckHook
  ];

  pythonImportsCheck = [ "aiohappyeyeballs" ];

  meta = {
    description = "Happy Eyeballs for pre-resolved hosts";
    homepage = "https://github.com/aio-libs/aiohappyeyeballs";
    changelog = "https://github.com/aio-libs/aiohappyeyeballs/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [
      fab
      hexa
    ];
  };
}
