{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  pymongo,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pymongo-inmemory";
  version = "0.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kaizendorks";
    repo = "pymongo_inmemory";
    rev = "refs/tags/v${version}";
    hash = "sha256-FDHHf9x62EqNcHjDF2vH8w8WG/15efEe+fDqGiiOe4A=";
  };

  postPatch = ''
    # move cache location from nix store to home
    substituteInPlace pymongo_inmemory/context.py \
      --replace-fail \
        'CACHE_FOLDER = path.join(path.dirname(__file__), "..", ".cache")' \
        'CACHE_FOLDER = os.environ.get("XDG_CACHE_HOME", os.environ["HOME"] + "/.cache") + "/pymongo-inmemory"'

    # fix a broken assumption arising from the above fix
    substituteInPlace pymongo_inmemory/_utils.py \
      --replace-fail \
        'os.mkdir(current_path)' \
        'os.makedirs(current_path)'
  '';

  nativeBuildInputs = [ poetry-core ];

  dependencies = [ pymongo ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # new test with insufficient monkey patching, try to remove on next bump
    "tests/unit/test_mongod.py"
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  pythonImportsCheck = [ "pymongo_inmemory" ];

  meta = {
    homepage = "https://github.com/kaizendorks/pymongo_inmemory";
    description = "Mongo mocking library with an ephemeral MongoDB running in memory";
    maintainers = with lib.maintainers; [ pbsds ];
    license = lib.licenses.mit;
  };
}
