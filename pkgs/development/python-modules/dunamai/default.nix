{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  packaging,

  # tests
  addBinToPathHook,
  gitMinimal,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "dunamai";
  version = "1.26.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = "dunamai";
    tag = "v${version}";
    hash = "sha256-pP0KeQ1tThvBomQIlrWNCVzB8ghR9rfaLm5NeBKwiuE=";
  };

  build-system = [ poetry-core ];

  dependencies = [ packaging ];

  preCheck = ''
    git config --global user.email "nobody@example.com"
    git config --global user.name "Nobody"
  '';

  nativeCheckInputs = [
    addBinToPathHook
    gitMinimal
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # clones from github.com
    "test__version__from_git__shallow"
  ];

  pythonImportsCheck = [ "dunamai" ];

  meta = {
    description = "Dynamic version generation";
    mainProgram = "dunamai";
    homepage = "https://github.com/mtkennerly/dunamai";
    changelog = "https://github.com/mtkennerly/dunamai/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jmgilman ];
  };
}
