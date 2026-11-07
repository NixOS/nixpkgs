{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  argh,
  msgspec,
  pexpect,
}:

buildPythonPackage (finalAttrs: {
  pname = "repl-session";
  version = "0.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "entangled";
    repo = "repl-session";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U3BiPyspDG0cSo6/3PvZ7++FNObWYVj/BHoT+f7CNXg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    argh
    msgspec
    pexpect
  ];

  pythonImportsCheck = [
    "repl_session"
  ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Runs a session with a Read-Eval-Print-Loop (REPL)";
    homepage = "https://github.com/entangled/repl-session";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mjm ];
  };
})
