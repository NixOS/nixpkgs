{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  replaceVars,
  graphviz,
  setuptools,
  markdown,
}:

buildPythonPackage rec {
  pname = "mkdocs-graphviz";
  version = "1.5";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "rod2ik";
    repo = "mkdocs-graphviz";
    tag = version;
    hash = "sha256-5pc5RpOrDSONZcgIQMNsVxYwFyJ+PMcIt0GXDxCEyOg=";
  };

  patches = [
    # Replace the path to the `graphviz` commands to use the one provided by Nixpkgs.
    (replaceVars ./replace-path-to-dot.patch {
      command = "\"${graphviz}/bin/\" + command";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    markdown
  ];

  pythonImportsCheck = [ "mkdocs_graphviz" ];

  # Tests are not available in the source code.
  doCheck = false;

  meta = {
    description = "Configurable Python markdown extension for graphviz and Mkdocs";
    homepage = "https://gitlab.com/rod2ik/mkdocs-graphviz";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
  };
}
