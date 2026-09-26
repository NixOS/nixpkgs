{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  writableTmpDirAsHomeHook,
  pytestCheckHook,
  pytest-subprocess,
  xonsh,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "xontrib-fish-completer";
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-fish-completer";
    tag = version;
    hash = "sha256-9S0Gj1CQxuX1mGL1+4Xyyld/NHUYUi7DJ424lUlExVc=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
    pytest-subprocess
    xonsh
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Populate rich completions using fish and remove the default bash based completer";
    homepage = "https://github.com/xonsh/xontrib-fish-completer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      greg
      infinidoge
    ];
  };
}
