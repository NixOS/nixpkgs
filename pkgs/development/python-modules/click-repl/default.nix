{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  click,
  prompt-toolkit,
  six,

  # tests
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "click-repl";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-repl";
    tag = version;
    hash = "sha256-xCT3w0DDY73dtDL5jbssXM05Zlr44OOcy4vexgHyWiE=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    click
    prompt-toolkit
    six
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = with lib; {
    # https://github.com/click-contrib/click-repl/issues/128
    broken = lib.versionAtLeast click.version "8.2.0";
    homepage = "https://github.com/click-contrib/click-repl";
    description = "Subcommand REPL for click apps";
    license = licenses.mit;
    maintainers = with maintainers; [ twey ];
  };
}
