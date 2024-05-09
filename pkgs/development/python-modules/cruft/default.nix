{ lib, python3Packages, fetchFromGitHub, fetchPypi }:
let
  # Pin the version of cookiecutter to 2.1.1, since upper versions seem to
  # break cruft functionalities.
  cookiecutter = python3Packages.cookiecutter.overridePythonAttrs
    (oldAttrs: rec {
      version = "2.1.1";
      pname = "cookiecutter";
      src = fetchPypi {
        inherit pname version;
        hash = "sha256-85gr6NnFPawSYYZAE/3sf4Ov0uQu3m9t0GnF4UnFQNU=";
      };
    });
in python3Packages.buildPythonApplication rec {
  pname = "cruft";
  version = "2.15.0";

  src = fetchFromGitHub {
    repo = "cruft";
    owner = "cruft";
    rev = "${version}";
    sha256 = "sha256-qIVyNMoI3LsoOV/6XPa60Y1vTRvkezesF7wF9WVSLGk=";
  };

  format = "pyproject";

  nativeBuildInputs = with python3Packages; [ poetry-core ];

  propagatedBuildInputs = with python3Packages; [
    click
    cookiecutter
    gitpython
    importlib-metadata
    toml
    typer
  ];

  meta = with lib; {
    description = "A utility to maintain boilerplate separated from a intentionally written code";
    homepage = "https://github.com/cruft/cruft";
    license = licenses.mit;
    maintainers = with maintainers; [ aacebedo avh4 ];
  };
}
