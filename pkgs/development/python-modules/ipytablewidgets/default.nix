{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, ipywidgets
, jupyter-packaging
, jupyterlab
, lz4
, numpy
, pandas
, setuptools
, traitlets
, traittypes
, wheel
}:

buildPythonPackage rec {
  pname = "ipytablewidgets";
  version = "0.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-14vIih+r/PHLxhgG29YtwuosSBLpewD2CluWpH2+pLc=";
  };

  nativeBuildInputs = [
    jupyter-packaging
    jupyterlab
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    ipywidgets
    lz4
    numpy
    pandas
    traitlets
    traittypes
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ipytablewidgets" ];

  meta = with lib; {
    description = "Traitlets and widgets to efficiently data tables (e.g. Pandas DataFrame) using the jupyter notebook";
    homepage = "https://github.com/progressivis/ipytablewidgets";
    license = licenses.bsd3;
    maintainers = with maintainers; [ natsukium ];
  };
}
