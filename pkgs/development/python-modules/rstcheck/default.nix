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
  version = "6.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rstcheck";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-UMByfnnP1va3v1IgyQL0f3kC+W6HoiWScb7U2FAvWkU=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

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
    changelog = "https://github.com/rstcheck/rstcheck/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ staccato ];
  };
}
