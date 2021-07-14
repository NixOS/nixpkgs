{ lib
, attrs
, bson
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, immutables
, msgpack
, poetry-core
, pytestCheckHook
, pyyaml
, tomlkit
, ujson
}:

buildPythonPackage rec {
  pname = "cattrs";
  version = "1.7.0";
  format = "pyproject";

  # https://cattrs.readthedocs.io/en/latest/history.html#id33:
  # "Python 2, 3.5 and 3.6 support removal. If you need it, use a version below 1.1.0."
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Tinche";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7F4S4IeApbULXhkEZ0oab3Y7sk20Ag2fCYxsyi4WbWw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    attrs
  ];

  checkInputs = [
    bson
    hypothesis
    immutables
    msgpack
    pytestCheckHook
    pyyaml
    tomlkit
    ujson
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "-l --benchmark-sort=fullname --benchmark-warmup=true --benchmark-warmup-iterations=5  --benchmark-group-by=fullname" ""
    substituteInPlace pyproject.toml \
      --replace 'orjson = "^3.5.2"' ""
    substituteInPlace tests/test_preconf.py \
      --replace "from orjson import dumps as orjson_dumps" "" \
      --replace "from orjson import loads as orjson_loads" ""
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
  ];

  pythonImportsCheck = [ "cattr" ];

  meta = with lib; {
    description = "Python custom class converters for attrs";
    homepage = "https://github.com/Tinche/cattrs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
