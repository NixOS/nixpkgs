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
  version = "5.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ivankorobkov";
    repo = "python-inject";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ws296ESjb+a322imiRRWTS43w32rJc/7Y//OBQXOwnw=";
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
