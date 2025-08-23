{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  click,
  pygments,
  prompt-toolkit,
  sqlparse,
  configobj,
  cli-helpers,
}:

buildPythonPackage rec {
  pname = "litecli";
  version = "1.12.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3XB8G8BAR6ptuhkW0gS+RwA6o4PPY4u+Dx1wvGVx1oE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    click
    pygments
    prompt-toolkit
    sqlparse
    configobj
    cli-helpers
  ];

  doCheck = false;

  pythonImportsCheck = [
    "litecli"
  ];

  meta = with lib; {
    description = "CLI for SQLite Databases with auto-completion and syntax highlighting";
    homepage = "https://github.com/dbcli/litecli";
    changelog = "https://github.com/dbcli/litecli/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nullstring1 ];
    mainProgram = "litecli";
  };
}
