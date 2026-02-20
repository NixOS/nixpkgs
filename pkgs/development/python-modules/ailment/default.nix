{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyvex,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "ailment";
  version = "9.2.154";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "ailment";
    tag = "v${version}";
    hash = "sha256-JjS+jYWrbErkb6uM0DtB5h2ht6ZMmiYOQL/Emm6wC5U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyvex
    typing-extensions
  ];

  # Tests depend on angr (possibly a circular dependency)
  doCheck = false;

  pythonImportsCheck = [ "ailment" ];

  meta = {
    description = "Angr Intermediate Language";
    homepage = "https://github.com/angr/ailment";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
