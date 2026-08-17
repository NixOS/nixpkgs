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
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-fish-completer";
    tag = version;
    hash = "sha256-PhhdZ3iLPDEIG9uDeR5ctJ9zz2+YORHBhbsiLrJckyA=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"xonsh>=0.12.5"' ""
  '';

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
    maintainers = with lib.maintainers; [ greg ];
  };
}
