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
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-jedi";
    tag = "v${version}";
    hash = "sha256-n2zJKlI52TMuYA6q822ZIHgxT6sGW+GE8paI5WB7Cyg=";
  };

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

  disabledTests = [
    # stdout not properly captured?
    "test_jedi_error_logged_when_debug_set"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Xonsh Python mode completions using jedi";
    homepage = "https://github.com/xonsh/xontrib-jedi";
    changelog = "https://github.com/xonsh/xontrib-jedi/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      greg
      infinidoge
    ];
  };
}
