{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  setuptools-scm,
  poetry-core,
  prompt-toolkit,
  writableTmpDirAsHomeHook,
  pytestCheckHook,
  xonsh,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "xontrib-abbrevs";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-abbrevs";
    tag = "v${version}";
    hash = "sha256-xJUSbYo/+RFFCHenDEybVNxpOrEqSkU3eAaI+TNTmQI=";
  };

  build-system = [
    setuptools
    setuptools-scm
    poetry-core
  ];

  dependencies = [
    prompt-toolkit
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
    xonsh
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command abbreviations for Xonsh";
    homepage = "https://github.com/xonsh/xontrib-abbrevs";
    changelog = "https://github.com/xonsh/xontrib-apprevs/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      greg
      infinidoge
    ];
  };
}
