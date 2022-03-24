{ lib, callPackage, buildPythonApplication, fetchFromGitHub
, jinja2
, markdown
, mkdocs
, mkdocs-material-extensions
, pygments
, pymdown-extensions
}:

buildPythonApplication rec {
  pname = "mkdocs-material";
  version = "8.2.6";

  src = fetchFromGitHub {
    owner = "squidfunk";
    repo = pname;
    rev = version;
    sha256 = "sha256-4t9LBZc73V8eAIUO+BAZPgak+AX3o2YKZJWug+b6TBY=";
  };

  propagatedBuildInputs = [
    jinja2
    markdown
    mkdocs
    mkdocs-material-extensions
    pygments
    pymdown-extensions
  ];

  # No tests for python
  doCheck = false;

  pythonImportsCheck = [ "mkdocs" ];

  meta = with lib; {
    description = "Material for mkdocs";
    homepage = "https://squidfunk.github.io/mkdocs-material/";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion ];
  };
}
