{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  pdm-backend,

  # dependencies
  exceptiongroup,
  hypercorn,
  quart,
  trio,

  # tests
  pytest-cov-stub,
  pytest-trio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "quart-trio";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pgjones";
    repo = "quart-trio";
    tag = version;
    hash = "sha256-n41XATex20iw3ZYxud/5cTdx+F6tTQQJmP91TIw2xJo=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    hypercorn
    quart
    trio
  ]
  ++ hypercorn.optional-dependencies.trio;

  pythonImportsCheck = [
    "quart_trio"
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-trio
    pytestCheckHook
  ];

  meta = {
    description = "Quart-Trio is an extension for Quart to support the Trio event loop";
    homepage = "https://github.com/pgjones/quart-trio";
    changelog = "https://github.com/pgjones/quart-trio/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
