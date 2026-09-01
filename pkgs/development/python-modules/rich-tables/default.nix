{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  coloraide,
  decorator,
  humanize,
  multimethod,
  platformdirs,
  rich,
  sqlparse,
  typing-extensions,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
  freezegun,

  # passthru
  rgbxy,
}:
buildPythonPackage (finalAttrs: {
  pname = "rich-tables";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snejus";
    repo = "rich-tables";
    tag = finalAttrs.version;
    hash = "sha256-LtmGvV3idKgQZcVGtRcwDmG5k7v+dTE1A07hmmrZSu0=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    coloraide
    decorator
    humanize
    multimethod
    platformdirs
    rich
    sqlparse
    typing-extensions
  ];

  nativeBuildInputs = [
    pytestCheckHook
    pytest-cov-stub
    freezegun
  ]
  ++ finalAttrs.finalPackage.passthru.optional-dependencies.hue;

  optional-dependencies = {
    hue = [
      rgbxy
    ];
  };

  pythonRelaxDeps = [
    "multimethod"
  ];

  pythonImportsCheck = [
    "rich_tables"
  ];

  meta = {
    description = "Ready-made rich tables for various purposes";
    homepage = "https://pypi.org/project/rich-tables/";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers._9999years
    ];
    mainProgram = "table";
  };
})
