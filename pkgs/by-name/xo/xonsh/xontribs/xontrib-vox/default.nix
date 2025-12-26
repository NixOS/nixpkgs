{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  virtualenv,
  writableTmpDirAsHomeHook,
  pytestCheckHook,
  pytest-subprocess,
  xonsh,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "xontrib-vox";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-vox";
    tag = version;
    hash = "sha256-OB1O5GZYkg7Ucaqak3MncnQWXhMD4BM4wXsYCDD0mhk=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"xonsh>=0.12.5"' ""
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    virtualenv
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
    pytest-subprocess
    xonsh
  ];

  disabledTests = [
    # Monkeypatch in test fails, preventing test from running
    "test_interpreter"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python virtual environment manager for the xonsh shell";
    homepage = "https://github.com/xonsh/xontrib-vox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ greg ];
  };
}
