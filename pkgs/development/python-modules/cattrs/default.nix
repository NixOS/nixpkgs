{
  lib,
  attrs,
  buildPythonPackage,
  cbor2,
  fetchFromGitHub,
  exceptiongroup,
  hatchling,
  hatch-vcs,
  hypothesis,
  immutables,
  motor,
  msgpack,
  msgspec,
  orjson,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  tomlkit,
  typing-extensions,
  ujson,
}:

buildPythonPackage rec {
  pname = "cattrs";
  version = "24.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-attrs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-LSP8a/JduK0h9GytfbN7/CjFlnGGChaa3VbbCHQ3AFE=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs =
    [ attrs ]
    ++ lib.optionals (pythonOlder "3.11") [
      exceptiongroup
      typing-extensions
    ];

  nativeCheckInputs = [
    cbor2
    hypothesis
    immutables
    motor
    msgpack
    msgspec
    orjson
    pytest-xdist
    pytestCheckHook
    pyyaml
    tomlkit
    typing-extensions
    ujson
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "-l --benchmark-sort=fullname --benchmark-warmup=true --benchmark-warmup-iterations=5  --benchmark-group-by=fullname" ""
    substituteInPlace tests/test_preconf.py \
      --replace "from orjson import dumps as orjson_dumps" "" \
      --replace "from orjson import loads as orjson_loads" ""
  '';

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTestPaths = [
    # Don't run benchmarking tests
    "bench/test_attrs_collections.py"
    "bench/test_attrs_nested.py"
    "bench/test_attrs_primitives.py"
    "bench/test_primitives.py"
  ];

  disabledTests = [
    # orjson is not available as it requires Rust nightly features to compile its requirements
    "test_orjson"
    # tomlkit is pinned to an older version and newer versions raise InvalidControlChar exception
    "test_tomlkit"
  ];

  pythonImportsCheck = [ "cattr" ];

  meta = with lib; {
    description = "Python custom class converters for attrs";
    homepage = "https://github.com/python-attrs/cattrs";
    changelog = "https://github.com/python-attrs/cattrs/blob/${src.rev}/HISTORY.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
