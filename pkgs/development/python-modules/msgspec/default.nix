{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  attrs,
  coverage,
  msgpack,
  pytestCheckHook,
  pyyaml,
  setuptools,
  setuptools-scm,
  tomli-w,
}:

buildPythonPackage rec {
  pname = "msgspec";
  version = "0.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "msgspec";
    repo = "msgspec";
    tag = version;
    hash = "sha256-ZCimTcAcFLWtmX0c8AqlkFD8KEgciHoNH63qvwArzak=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  optional-dependencies = {
    toml = [ tomli-w ];
    yaml = [ pyyaml ];
  };

  # pytest-randomly is only used to shuffle tests. Including it creates a
  # dependency cycle through factory-boy, Django, GDAL, and cattrs.
  nativeCheckInputs = [
    attrs
    coverage
    msgpack
    pytestCheckHook
  ]
  ++ optional-dependencies.yaml
  ++ optional-dependencies.toml;

  # `tests/typing` runs type checkers
  enabledTestPaths = [ "tests/unit" ];

  pythonImportsCheck = [ "msgspec" ];

  meta = {
    description = "Module to handle JSON/MessagePack";
    homepage = "https://msgspec.dev";
    changelog = "https://github.com/msgspec/msgspec/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
