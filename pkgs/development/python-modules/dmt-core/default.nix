{
  lib,
  stdenv,
  fetchPypi,
  buildPythonPackage,
  colormath,
  cycler,
  h5py,
  joblib,
  more-itertools,
  pandas,
  pint,
  pyarrow,
  pyyaml,
  requests,
  setuptools,
  scikit-rf,
  scipy,
  numpy,
  semver,
  reprint,
  verilogae,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dmt-core";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "DMT_core";
    hash = "sha256-489E+uNn4NgyCwxsUMEPH/1ZuM+5uNq4zx8F88rkHMU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colormath
    cycler
    h5py
    joblib
    more-itertools
    pandas
    pint
    pyarrow
    pyyaml
    requests
    scikit-rf
    scipy
    setuptools
    numpy
    semver
    reprint
    verilogae
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "DMT.core" ];

  LD_LIBRARY_PATH = "${stdenv.cc.cc.lib}/lib/";

  checkPhase = ''
    export XDG_CONFIG_HOME=$PWD/config
    mkdir -p $XDG_CONFIG_HOME/DMT
    touch $XDG_CONFIG_HOME/DMT/DMT_config.yaml
  '';

  meta = {
    changelog = "https://gitlab.com/dmt-development/dmt-core/-/blob/Version_${version}/CHANGELOG?ref_type=tags";
    description = "Tool to help modeling engineers extract model parameters, run circuit and TCAD simulations and automate infrastructure";
    homepage = "https://gitlab.com/dmt-development/dmt-core";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jasonodoom ];
  };
}
