{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mkdocs,
}:
buildPythonPackage rec {
  pname = "mkdocs-simple-blog";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FernandoCelmer";
    repo = "mkdocs-simple-blog";
    tag = "v${version}";
    hash = "sha256-pzoQb5cBzd7Gt2jbai4cr37i5n30y0lfaukhQETSsjA=";
  };

  dependencies = [
    mkdocs
  ];

  # Add a postPatch phase to fix the module structure if needed
  postPatch = ''
    # Ensure the package is importable
    if [ ! -d "mkdocs_simple_blog" ] && [ -d "mkdocs-simple-blog" ]; then
      mv mkdocs-simple-blog mkdocs_simple_blog
    fi

    # Create an __init__.py if it doesn't exist
    if [ ! -f "mkdocs_simple_blog/__init__.py" ]; then
      touch mkdocs_simple_blog/__init__.py
    fi
  '';

  # Since there are no tests in the repository, we can disable the test phase
  # but still check that the module can be imported
  doCheck = false;

  pythonImportsCheck = [ "mkdocs_simple_blog" ];

  meta = {
    description = "Simple blog generator plugin for MkDocs";
    homepage = "https://github.com/FernandoCelmer/mkdocs-simple-blog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
