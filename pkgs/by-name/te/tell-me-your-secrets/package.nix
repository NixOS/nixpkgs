{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "tell-me-your-secrets";
  version = "2.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "valayDave";
    repo = "tell-me-your-secrets";
    tag = "v${version}";
    hash = "sha256-3ZJyL/V1dsW6F+PiEhnWpv/Pz2H9/UKSJWDgw68M/Z8=";
  };

  pythonRelaxDeps = [
    "pandas"
    "single-source"
  ];

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    gitignore-parser
    pandas
    pyyaml
    single-source
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "tell_me_your_secrets" ];

  meta = {
    description = "Tools to find secrets from various signatures";
    mainProgram = "tell-me-your-secrets";
    homepage = "https://github.com/valayDave/tell-me-your-secrets";
    changelog = "https://github.com/valayDave/tell-me-your-secrets/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
