{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  ipykernel,
  jupytext,
  mkdocs,
  mkdocs-material,
  nbconvert,
  pygments,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mkdocs-jupyter";
  version = "0.24.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "mkdocs_jupyter";
    inherit version;
    hash = "sha256-Cadi9ITVQNnA6UTTSyjLU2oyhp4iS0YOL8eRsUP3aUA=";
  };

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
    substituteInPlace src/mkdocs_jupyter/tests/test_base_usage.py \
      --replace "[\"mkdocs\"," "[\"${mkdocs.out}/bin/mkdocs\","
  '';

  pythonRelaxDeps = [ "nbconvert" ];

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    ipykernel
    jupytext
    mkdocs
    mkdocs-material
    nbconvert
    pygments
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mkdocs_jupyter" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Use Jupyter Notebook in mkdocs";
    homepage = "https://github.com/danielfrg/mkdocs-jupyter";
    changelog = "https://github.com/danielfrg/mkdocs-jupyter/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ net-mist ];
  };
}
