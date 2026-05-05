{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  cyclopts,
  deno,
  pydantic,
  rich,

  # tests
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "prefab-ui";
  version = "0.19.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PrefectHQ";
    repo = "prefab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-caSsMR6Il4D1l9Y1ScdN5HZ4TPG2YyB6JzctDt+W3WE=";
  };

  patches = [
    # Fix packaging of static skills directory.
    (fetchpatch {
      # This commit has been submitted in a PR to the upstream repo: https://github.com/PrefectHQ/prefab/pull/433.
      url = "https://github.com/PrefectHQ/prefab/commit/5860b2f3099117d800ca17c10fd3edcb67e07873.patch";
      hash = "sha256-Eph0PDucH3J7OUP+YQWH6qYycYdLkG52Y6xYNIQUilQ=";
    })
  ];

  # Remove the `dev` command; this command is _not_ user-facing
  # and fails entirely in nix because it needs several
  # undocumented dependencies (npx, uv, etc) and tries to
  # generate files in the repository root, i.e. the Nix store.
  postPatch = ''
    substituteInPlace src/prefab_ui/cli/cli.py \
      --replace-fail "app.command(dev_app)" ""

    substituteInPlace src/prefab_ui/sandbox/_pyodide.py \
      tests/test_generative.py \
      tests/test_sandbox.py \
      --replace-fail 'import shutil' 'import pathlib' \
      --replace-fail 'shutil.which("deno")' 'pathlib.Path("${lib.getExe deno}")'
  '';

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    cyclopts
    pydantic
    rich
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
    versionCheckHook
  ];

  disabledTestPaths = [
    # Tests used to validate dev tooling, which we disable.
    "tests/test_contract.py"
    # Tests use Pyodide, which tries to access the network to download Pyodide from npm.
    "tests/test_generative.py"
    "tests/test_sandbox.py"
  ];

  pythonImportsCheck = [ "prefab_ui" ];

  meta = {
    description = "Generative UI framework that even humans can use";
    homepage = "https://github.com/PrefectHQ/prefab";
    changelog = "https://github.com/PrefectHQ/prefab/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ squat ];
    mainProgram = "prefab";
  };
})
