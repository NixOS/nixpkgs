{
  lib,
  fetchFromGitLab,
  python3,
  nix-update-script,
}:
python3.pkgs.buildPythonApplication {
  pname = "yaookctl";
  version = "0-unstable-2026-07-02";

  src = fetchFromGitLab {
    owner = "yaook";
    repo = "yaookctl";
    rev = "d444a887e0350a62b8b23d761a849ec7db46ad65";
    hash = "sha256-EWKKwPnR15qkRuhuGRyj5otwUVX+sOmRei4WfN3aRpQ=";
  };

  pyproject = true;
  build-system = [ python3.pkgs.setuptools ];

  dontCheckRuntimeDeps = true;

  dependencies = with python3.pkgs; [
    babel
    click
    click-option-group
    kubernetes-asyncio
    prettytable
    typing-extensions
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://gitlab.com/yaook/yaookctl";
    description = "Toolbox for interacting with Yaook clusters";
    license = lib.licenses.mit;
    mainProgram = "yaookctl";
    maintainers = with lib.maintainers; [ lykos153 ];
  };
}
