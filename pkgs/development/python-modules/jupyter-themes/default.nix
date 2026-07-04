{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lesscpy,
  matplotlib,
  notebook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jupyter-themes";
  version = "0.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dunovank";
    repo = "jupyter-themes";
    tag = "v${version}";
    hash = "sha256-AWbUXMOA6k2LpZtcJOPxTZb1oL5vLDbBq4aEhXWvy9M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lesscpy
    matplotlib
    notebook
  ];

  pythonImportsCheck = [ "jupyterthemes" ];

  meta = {
    description = "Theme-ify your Jupyter Notebooks!";
    homepage = "https://github.com/dunovank/jupyter-themes";
    changelog = "https://github.com/dunovank/jupyter-themes/blob/v${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "jupyter-theme";
  };
}
