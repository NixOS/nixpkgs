{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
}:

buildPythonPackage rec {
  pname = "mkdocs-material-extensions";
  version = "1.3.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-/jU30Ol10/4haR3ZPJWZ3iWRfXG/RUOU1oclOYGjjAY=";
  };

  nativeBuildInputs = [ hatchling ];

  doCheck = false; # Circular dependency

  pythonImportsCheck = [ "materialx" ];

  meta = with lib; {
    description = "Markdown extension resources for MkDocs Material";
    homepage = "https://github.com/facelessuser/mkdocs-material-extensions";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion ];
  };
}
