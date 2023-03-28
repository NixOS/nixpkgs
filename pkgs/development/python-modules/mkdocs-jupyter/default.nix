{ buildPythonPackage
, fetchPypi
, hatchling
, ipykernel
, jupytext
, lib
, mkdocs
, mkdocs-material
, nbconvert
, pygments
, pytestCheckHook
, pytest-cov
}:

buildPythonPackage rec {
  pname = "mkdocs-jupyter";
  version = "0.24.1";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "mkdocs_jupyter";
    hash = "sha256-lncDf7fpMSaPPfdZn8CCjCYSR989FXW87TILqLfR1G0=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    nbconvert
    jupytext
    mkdocs
    mkdocs-material
    pygments
    ipykernel
  ];

  pythonImportsCheck = [ "mkdocs_jupyter" ];

  checkInputs = [
    pytest-cov
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Use Jupyter Notebook in mkdocs";
    homepage = "https://github.com/danielfrg/mkdocs-jupyter";
    license = licenses.asl20;
    maintainers = with maintainers; [ net-mist ];
  };
}
