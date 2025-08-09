{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  direnv,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "xonsh-direnv";
  version = "1.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "74th";
    repo = "xonsh-direnv";
    tag = version;
    hash = "sha256-huBJ7WknVCk+WgZaXHlL+Y1sqsn6TYqMP29/fsUPSyU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    direnv
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Direnv support for Xonsh";
    homepage = "https://github.com/74th/xonsh-direnv/";
    changelog = "https://github.com/74th/xonsh-direnv/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ greg ];
  };
}
