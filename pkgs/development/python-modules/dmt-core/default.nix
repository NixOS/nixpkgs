{
  buildPythonPackage,
  colormath,
  cycler,
  fetchPypi,
  h5py,
  joblib,
  lib,
  more-itertools,
  numpy,
  pandas,
  pint,
  pyarrow,
  pytest,
  pyyaml,
  reprint,
  requests,
  scikit-rf,
  scipy,
  semver,
  setuptools,
  verilogae,
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

  build-system = [
    setuptools
  ];

  dependencies = [
    colormath
    cycler
    h5py
    joblib
    more-itertools
    pandas
    pint
    pyarrow
    pytest
    pyyaml
    requests
    scikit-rf
    scipy
    setuptools
    numpy
    semver
  ];

  nativeBuildInputs = [
    reprint
    verilogae
  ];

  preConfigure = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "DMT.core"
    "reprint"
    "verilogae"
  ];

  meta = {
    changelog = "https://gitlab.com/dmt-development/dmt-core/-/blob/Version_${version}/CHANGELOG?ref_type=tags";
    description = "Tool to help modeling engineers extract model parameters, run circuit and TCAD simulations and automate infrastructure";
    homepage = "https://gitlab.com/dmt-development/dmt-core";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      jasonodoom
      jleightcap
    ];
    teams = with lib.teams; [ ngi ];
  };
}
