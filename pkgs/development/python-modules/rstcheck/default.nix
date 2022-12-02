{ lib
, buildPythonPackage
, docutils
, fetchFromGitHub
, importlib-metadata
, poetry-core
, pydantic
, pytestCheckHook
, pythonOlder
, rstcheck-core
, typer
, types-docutils
, typing-extensions
}:

buildPythonPackage rec {
  pname = "rstcheck";
  version = "6.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rstcheck";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dw/KggiZpKaFZMcTIaSBUhR4oQsZI3iSmEj9Sy80wTs=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    docutils
    rstcheck-core
    types-docutils
    typing-extensions
    pydantic
    typer
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
    importlib-metadata
  ] ++ typer.optional-dependencies.all;

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'docutils = ">=0.7, <0.19"' 'docutils = ">=0.7"' \
      --replace 'types-docutils = ">=0.18, <0.19"' 'types-docutils = ">=0.18"'
  '';

  pythonImportsCheck = [
    "rstcheck"
  ];

  preCheck = ''
    # The tests need to find and call the rstcheck executable
    export PATH="$PATH:$out/bin";
  '';

  meta = with lib; {
    description = "Checks syntax of reStructuredText and code blocks nested within it";
    homepage = "https://github.com/myint/rstcheck";
    license = licenses.mit;
    maintainers = with maintainers; [ staccato ];
  };
}
