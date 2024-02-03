{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, jupyter-contrib-core
, jupyter-core
, jupyter-server
, notebook
, pyyaml
, tornado
, nose
, pytestCheckHook
, selenium
}:

buildPythonPackage rec {
  pname = "jupyter-nbextensions-configurator";
  version = "0.6.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jupyter-contrib";
    repo = "jupyter_nbextensions_configurator";
    rev = "refs/tags/${version}";
    hash = "sha256-ovKYHATRAC5a5qTMv32ohU2gJd15/fRKXa5HI0zGp/0=";
  };

  patches = [
    # https://github.com/Jupyter-contrib/jupyter_nbextensions_configurator/pull/166
    (fetchpatch {
      name = "notebook-v7-compat.patch";
      url = "https://github.com/Jupyter-contrib/jupyter_nbextensions_configurator/commit/a600cef9222ca0c61a6912eb29d8fa0323409705.patch";
      hash = "sha256-Rt9r5ZOgnhBcs18+ET5+k0/t980I2DiVN8oHkGLp0iw=";
    })
  ];

  propagatedBuildInputs = [
    jupyter-contrib-core
    jupyter-core
    jupyter-server
    notebook
    pyyaml
    tornado
  ];

  nativeCheckInputs = [
    nose
    pytestCheckHook
    selenium
  ];

  # Those tests fails upstream
  disabledTestPaths = [
    "tests/test_application.py"
    "tests/test_jupyterhub.py"
    "tests/test_nbextensions_configurator.py"
  ];

  pythonImportsCheck = [ "jupyter_nbextensions_configurator" ];

  meta = with lib; {
    description = "A jupyter notebook serverextension providing config interfaces for nbextensions";
    homepage = "https://github.com/jupyter-contrib/jupyter_nbextensions_configurator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
