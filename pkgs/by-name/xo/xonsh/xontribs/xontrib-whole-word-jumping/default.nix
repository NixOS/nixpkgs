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
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-whole-word-jumping";
    tag = version;
    hash = "sha256-zLAOGW9prjYDQBDITFNMggn4X1JTyAnVdjkBOH9gXPs=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"xonsh>=0.12.5", ' ""
  '';

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
    maintainers = with lib.maintainers; [ greg ];
  };
}
