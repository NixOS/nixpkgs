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
  gitSetupHook,
  pytestCheckHook,
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

  nativeCheckInputs = [
    addBinToPathHook
    gitMinimal
    pytestCheckHook
    gitSetupHook
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
