{
  lib,
  buildPythonPackage,
  fetchPypi,
  babel,
  ipykernel,
  ipython-genutils,
  jupyter-packaging,
  jupyter-server,
  nest-asyncio,
  notebook-shim,
  pytest-jupyter,
  pytest-tornasync,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "nbclassic";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c27FBIOlRIWXHbITvpIH405R/BRMeDQ2JbaZF0I2RLo=";
  };

  build-system = [
    babel
    jupyter-packaging
    jupyter-server
  ];

  dependencies = [
    ipykernel
    ipython-genutils
    nest-asyncio
    notebook-shim
  ];

  nativeCheckInputs = [
    pytest-jupyter
    pytest-tornasync
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nbclassic" ];

  __darwinAllowLocalNetworking = true;

<<<<<<< HEAD
  meta = {
    description = "Jupyter lab environment notebook server extension";
    homepage = "https://github.com/jupyter/nbclassic";
    license = with lib.licenses; [ bsd3 ];
=======
  meta = with lib; {
    description = "Jupyter lab environment notebook server extension";
    homepage = "https://github.com/jupyter/nbclassic";
    license = with licenses; [ bsd3 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
