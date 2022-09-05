{ lib
, buildPythonPackage
, colorama
, docutils
, fetchFromGitHub
, importlib-metadata
, poetry-core
, pydantic
, pytestCheckHook
, pythonOlder
, rstcheck-core
, shellingham
, typer
, types-docutils
, typing-extensions
}:

buildPythonPackage rec {
  pname = "rstcheck";
  version = "6.0.0.post1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rstcheck";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ljg1cciT9qKL9xtBxQ8OLygDpV/1yR5XiJOzHrLr6xw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    colorama
    docutils
    rstcheck-core
    shellingham
    types-docutils
    typing-extensions
    pydantic
    typer
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
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
