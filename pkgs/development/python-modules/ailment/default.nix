{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pyvex,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "ailment";
  version = "9.2.149";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "ailment";
    tag = "v${version}";
    hash = "sha256-hgTJMWprK4M+9Ae/E5jz5mkJjBgro4zYJLrVx96zQ20=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyvex
    typing-extensions
  ];

  # Tests depend on angr (possibly a circular dependency)
  doCheck = false;

  pythonImportsCheck = [ "ailment" ];

  meta = with lib; {
    description = "Angr Intermediate Language";
    homepage = "https://github.com/angr/ailment";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
