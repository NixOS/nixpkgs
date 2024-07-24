{
  lib,
  buildPythonPackage,
  fetchPypi,
  attrs,
  click,
  flit-core,
  importlib-metadata,
  nbclient,
  nbformat,
  pyyaml,
  sqlalchemy,
  tabulate,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "jupyter-cache";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "jupyter_cache";
    hash = "sha256-0Pp9dTPNV5gZjYiJMYJpqME4LtOyL2IsCak1ZSH0hoc=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    attrs
    click
    importlib-metadata
    nbclient
    nbformat
    pyyaml
    sqlalchemy
    tabulate
  ];

  pythonImportsCheck = [ "jupyter_cache" ];

  meta = with lib; {
    description = "Defined interface for working with a cache of jupyter notebooks";
    mainProgram = "jcache";
    homepage = "https://github.com/executablebooks/jupyter-cache";
    changelog = "https://github.com/executablebooks/jupyter-cache/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
