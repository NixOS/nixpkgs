{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# dependencies
, click
, prompt-toolkit
, six

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click-repl";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-repl";
    rev = "refs/tags/${version}";
    hash = "sha256-xCT3w0DDY73dtDL5jbssXM05Zlr44OOcy4vexgHyWiE=";
  };

  postPatch = ''
    sed -i '/--cov=/d' pyproject.toml
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    click
    prompt-toolkit
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/click-contrib/click-repl";
    description = "Subcommand REPL for click apps";
    license = licenses.mit;
    maintainers = with maintainers; [ twey ];
  };
}
