{ buildPythonPackage
, fetchPypi
, setuptools
, wheel
, comm
, ipykernel
, ipython
, jsonschema
, jupyterlab-widgets
, lib
, pytestCheckHook
, pytz
, traitlets
, widgetsnbextension
}:

buildPythonPackage rec {
  pname = "ipywidgets";
  version = "8.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0Lm0Hkm66SaoZuYTo5sPAJd0XSufHz3UBmQbSlfsQsk=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    comm
    ipython
    jupyterlab-widgets
    traitlets
    widgetsnbextension
  ];

  nativeCheckInputs = [
    ipykernel
    jsonschema
    pytestCheckHook
    pytz
  ];

  pytestFlagsArray = [
    # pytest.PytestRemovedIn8Warning: Support for nose tests is deprecated and will be removed in a future release.
    "-W" "ignore::pytest.PytestRemovedIn8Warning"
  ];

  meta = {
    description = "IPython HTML widgets for Jupyter";
    homepage = "https://github.com/jupyter-widgets/ipywidgets";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
