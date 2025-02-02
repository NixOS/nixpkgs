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
  version = "1.23.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = "dunamai";
    tag = "v${version}";
    hash = "sha256-JuW/VL8kfzz5mSXRHtrg/hHykgcewaQYfDuO2PALbWc=";
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
    changelog = "https://github.com/mtkennerly/dunamai/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jmgilman ];
  };
}
