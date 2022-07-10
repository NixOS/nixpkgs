{ lib
, callPackage
, buildPythonApplication
, fetchFromGitHub
, jinja2
, markdown
, mkdocs
, mkdocs-material-extensions
, pygments
, pymdown-extensions
, pythonOlder
}:

buildPythonApplication rec {
  pname = "mkdocs-material";
  version = "8.3.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "squidfunk";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-LOsgWRjKFZ+ZkJkQzDStNNBUh+AwlI8zZcUBz7L/Ook=";
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

  pythonImportsCheck = [
    "mkdocs"
  ];

  meta = with lib; {
    description = "Material for mkdocs";
    homepage = "https://squidfunk.github.io/mkdocs-material/";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion ];
  };
}
