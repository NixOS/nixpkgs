{ lib
, attrs
, buildPythonPackage
<<<<<<< HEAD
, cbor2
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, exceptiongroup
, hypothesis
, immutables
, motor
, msgpack
, orjson
, poetry-core
, pytest-xdist
, pytestCheckHook
, pythonOlder
, pyyaml
, tomlkit
, typing-extensions
, ujson
}:

buildPythonPackage rec {
  pname = "cattrs";
<<<<<<< HEAD
  version = "23.1.2";
=======
  version = "22.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-attrs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-YO4Clbo5fmXbysxwwM2qCHJwO5KwDC05VctRVFruJcw=";
=======
    hash = "sha256-Qnrq/mIA/t0mur6IAen4vTmMIhILWS6v5nuf+Via2hA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    attrs
  ] ++ lib.optionals (pythonOlder "3.11") [
    exceptiongroup
<<<<<<< HEAD
=======
  ] ++ lib.optionals (pythonOlder "3.7") [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    typing-extensions
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
    cbor2
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    hypothesis
    immutables
    motor
    msgpack
    orjson
    pytest-xdist
    pytestCheckHook
    pyyaml
    tomlkit
<<<<<<< HEAD
    typing-extensions
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ujson
  ];


  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "-l --benchmark-sort=fullname --benchmark-warmup=true --benchmark-warmup-iterations=5  --benchmark-group-by=fullname" "" \
      --replace 'orjson = "^3.5.2"' "" \
      --replace "[tool.poetry.group.dev.dependencies]" "[tool.poetry.dev-dependencies]"
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

  pythonImportsCheck = [
    "cattr"
  ];

  meta = with lib; {
    description = "Python custom class converters for attrs";
    homepage = "https://github.com/python-attrs/cattrs";
<<<<<<< HEAD
    changelog = "https://github.com/python-attrs/cattrs/blob/${src.rev}/HISTORY.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
