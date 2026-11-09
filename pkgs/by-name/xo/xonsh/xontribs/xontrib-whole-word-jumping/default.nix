{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  writableTmpDirAsHomeHook,
  pytestCheckHook,
  xonsh,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "xontrib-whole-word-jumping";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-whole-word-jumping";
    tag = version;
    hash = "sha256-quwtTIPEVcVAyVIE//nNkW0O8gwUT2Adaxr3esoTjh8=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
    xonsh
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Additional keyboard navigation for interactive xonsh shells";
    homepage = "https://github.com/xonsh/xontrib-whole-word-jumping";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      greg
      infinidoge
    ];
  };
}
