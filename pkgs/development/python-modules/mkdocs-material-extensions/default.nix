{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
}:

buildPythonPackage rec {
  pname = "mkdocs-material-extensions";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = "mkdocs-material-extensions";
    tag = version;
    hash = "sha256-/jU30Ol10/4haR3ZPJWZ3iWRfXG/RUOU1oclOYGjjAY=";
  };

  nativeBuildInputs = [ hatchling ];

  doCheck = false; # Circular dependency

  pythonImportsCheck = [ "materialx" ];

  meta = {
    description = "Markdown extension resources for MkDocs Material";
    homepage = "https://github.com/facelessuser/mkdocs-material-extensions";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
