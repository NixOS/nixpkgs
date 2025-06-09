{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "updog";
  version = "1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sc0tfree";
    repo = "updog";
    tag = version;
    hash = "sha256-e6J4Cbe9ZRb+nDMi6uxwP2ZggbNDyKysQC+IcKCDtIw=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    colorama
    flask
    flask-httpauth
    werkzeug
    pyopenssl
  ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  # no python tests

  meta = {
    description = "Replacement for Python's SimpleHTTPServer";
    mainProgram = "updog";
    homepage = "https://github.com/sc0tfree/updog";
    changelog = "https://github.com/sc0tfree/updog/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
