{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  mkdocs,
  pytestCheckHook,
  mock,
  pillow,
  ase,
}:
buildPythonPackage rec {
  pname = "mkdocs-simple-blog";
  version = "0.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "FernandoCelmer";
    repo = pname;
    rev = "6a9971496ca8b7f53d0c78fe7859ca266583f866";
    hash = "sha256-opl+8BRejr/cs3TrhFMZK9Xbq96kEQ6qVhI3EKDn858=";
  };

  propagatedBuildInputs = [
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
    description = "A simple blog generator plugin for MkDocs";
    homepage = "https://github.com/FernandoCelmer/mkdocs-simple-blog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
