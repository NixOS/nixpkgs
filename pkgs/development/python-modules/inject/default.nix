{
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  lib,
  nix-update-script,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "inject";
  version = "5.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ivankorobkov";
    repo = "python-inject";
    tag = "v${version}";
    hash = "sha256-c/OpEsT9KF7285xfD+VRorrNHn3r9IPp/ts9JHyGK9s=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "inject" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python dependency injection framework";
    homepage = "https://github.com/ivankorobkov/python-inject";
    changelog = "https://github.com/ivankorobkov/python-inject/blob/${version}/CHANGES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ perchun ];
  };
}
