{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, poetry-core
, pymongo
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pymongo-inmemory";
  version = "0.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kaizendorks";
    repo = "pymongo_inmemory";
    rev = "refs/tags/v${version}";
    hash = "sha256-1v36cI6JjDZA/uJE85NSMNnoyKI1VCgDrymfnCkpVqU=";
  };

  postPatch = ''
    # move cache location from nix store to home
    substituteInPlace pymongo_inmemory/context.py \
      --replace \
        'CACHE_FOLDER = path.join(path.dirname(__file__), "..", ".cache")' \
        'CACHE_FOLDER = os.environ.get("XDG_CACHE_HOME", os.environ["HOME"] + "/.cache") + "/pymongo-inmemory"'

    # fix a broken assumption arising from the above fix
    substituteInPlace pymongo_inmemory/_utils.py \
      --replace \
        'os.mkdir(current_path)' \
        'os.makedirs(current_path)'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pymongo
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  pythonImportsCheck = [
    "pymongo_inmemory"
  ];

  meta = {
    homepage = "https://github.com/kaizendorks/pymongo_inmemory";
    description = "A mongo mocking library with an ephemeral MongoDB running in memory";
    maintainers = with lib.maintainers; [ pbsds ];
    license = lib.licenses.mit;
  };
}
