{
  lib,
  attrs,
  buildPythonPackage,
  cbor2,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  hypothesis,
  immutables,
  motor,
  msgpack,
  msgspec,
  orjson,
  pymongo,
  pytest-xdist,
  pytestCheckHook,
  pyyaml,
  tomli-w,
  tomlkit,
  typing-extensions,
  ujson,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cattrs";
  version = "26.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-attrs";
    repo = "cattrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i1C7TvtQhiEZPi4YELxPHkiz33nNw2rtgRTqs98PVlc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "-l --benchmark-sort=fullname --benchmark-warmup=true --benchmark-warmup-iterations=5  --benchmark-group-by=fullname" ""
  '';

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    attrs
    typing-extensions
  ];

  optional-dependencies = {
    ujson = [
      ujson
    ];
    orjson = [
      orjson
    ];
    msgpack = [
      msgpack
    ];
    pyyaml = [
      pyyaml
    ];
    tomlkit = [
      tomlkit
    ];
    cbor2 = [
      cbor2
    ];
    bson = [
      pymongo
    ];
    msgspec = [
      msgspec
    ];
    tomllib = [
      tomli-w
    ];
  };

  nativeCheckInputs = [
    hypothesis
    immutables
    motor
    pytest-xdist
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTestPaths = [
    # Don't run benchmarking tests
    "bench"
  ];

  pythonImportsCheck = [ "cattr" ];

  meta = {
    changelog = "https://github.com/python-attrs/cattrs/blob/${finalAttrs.src.tag}/HISTORY.md";
    description = "Python custom class converters for attrs";
    homepage = "https://github.com/python-attrs/cattrs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
