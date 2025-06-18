{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  poetry-core,
  jedi,
  writableTmpDirAsHomeHook,
  pytestCheckHook,
  xonsh,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "xontrib-jedi";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-jedi";
    tag = "v${version}";
    hash = "sha256-T4Yxr91emM2mjclQOjQsnnPO/JijAGNcqmZjxrz72Bs=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'xonsh = ">=0.17"' ""
  '';

  build-system = [
    poetry-core
  ];

  dependencies = [
    jedi
  ];

  preCheck = ''
    substituteInPlace tests/test_jedi.py \
      --replace-fail "/usr/bin" "${jedi}/bin"
  '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
    xonsh
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Xonsh Python mode completions using jedi";
    homepage = "https://github.com/xonsh/xontrib-jedi";
    changelog = "https://github.com/xonsh/xontrib-jedi.releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ greg ];
  };
}
