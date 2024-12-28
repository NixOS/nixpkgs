{
  lib,
  attrs,
  buildPythonPackage,
  cbor2,
  fetchFromGitHub,
  fetchpatch2,
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
  pythonAtLeast,
  pythonOlder,
  pyyaml,
  tomlkit,
  typing-extensions,
  ujson,
}:

buildPythonPackage rec {
  pname = "cattrs";
  version = "24.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-attrs";
    repo = "cattrs";
    rev = "refs/tags/v${version}";
    hash = "sha256-LSP8a/JduK0h9GytfbN7/CjFlnGGChaa3VbbCHQ3AFE=";
  };

  patches = [
    # https://github.com/python-attrs/cattrs/pull/576
    (fetchpatch2 {
      name = "attrs-24_2-compatibility1.patch";
      url = "https://github.com/python-attrs/cattrs/commit/2d37226ff19506e23bbc291125a29ce514575819.patch";
      excludes = [
        "pyproject.toml"
        "pdm.lock"
      ];
      hash = "sha256-nbk7rmOFk42DXYdOgw4Oe3gl3HbxNEtaJ7ZiVSBb3YA=";
    })
    (fetchpatch2 {
      name = "attrs-24_2-compatibility2.patch";
      url = "https://github.com/python-attrs/cattrs/commit/4bd6dde556042241c6381e1993cedd6514921f58.patch";
      hash = "sha256-H1xSAYjvVUI8/jON3LWg2F2TlSxejf6TU1jpCeqly6I=";
    })
  ];

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies =
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
      --replace-fail "-l --benchmark-sort=fullname --benchmark-warmup=true --benchmark-warmup-iterations=5  --benchmark-group-by=fullname" ""
    substituteInPlace tests/test_preconf.py \
      --replace-fail "from orjson import dumps as orjson_dumps" "" \
      --replace-fail "from orjson import loads as orjson_loads" ""
  '';

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTestPaths = [
    # Don't run benchmarking tests
    "bench"
  ];

  disabledTests =
    [
      # orjson is not available as it requires Rust nightly features to compile its requirements
      "test_orjson"
      # msgspec causes a segmentation fault for some reason
      "test_simple_classes"
      "test_msgspec_json_converter"
    ]
    ++ lib.optionals (pythonAtLeast "3.13") [
      # https://github.com/python-attrs/cattrs/pull/543
      "test_unstructure_deeply_nested_generics_list"
    ];

  pythonImportsCheck = [ "cattr" ];

  meta = {
    description = "Python custom class converters for attrs";
    homepage = "https://github.com/python-attrs/cattrs";
    changelog = "https://github.com/python-attrs/cattrs/blob/${src.rev}/HISTORY.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
