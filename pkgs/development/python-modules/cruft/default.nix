{ lib, buildPythonPackage, fetchPypi, poetry-core
, click, cookiecutter, gitpython, importlib-metadata, toml, typer
}:

buildPythonPackage rec {
  pname = "cruft";
  version = "2.15.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mAKvZgN0GGVefktvMLUxWR4HYZObP/XdRdJ8Oj9Yir4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];
  propagatedBuildInputs = [
    click
    cookiecutter
    gitpython
    importlib-metadata
    toml
    typer
  ];

  meta = with lib; {
    homepage = "https://cruft.github.io/cruft/";
    description = "A command-line utility that updates projects using cookiecutter templates";
    license = licenses.mit;
    maintainers = with maintainers; [ avh4 ];
  };
}
