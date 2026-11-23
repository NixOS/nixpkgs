{
  lib,
  buildPythonPackage,
  colormath,
  cycler,
  fetchFromGitLab,
  h5py,
  joblib,
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
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "dmt-core";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "dmt-development";
    repo = "dmt-core";
    tag = "Version_${finalAttrs.version}";
    hash = "sha256-w+xGp34oXvyii977u0b1j57BtYnbOrZ5QZ6U/0PBOfw=";
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
    numpy
    pandas
    pint
    pyarrow
    pytest
    pyyaml
    reprint
    requests
    scikit-rf
    scipy
    semver
    setuptools
    verilogae
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'version="9.9.9"' 'version="${finalAttrs.version}"'
    substituteInPlace DMT/config/__init__.py \
      --replace-fail 'pkgutil.get_loader("DMT.extraction")' 'None'
    substituteInPlace DMT/core/__init__.py \
      --replace-fail 'pkgutil.find_loader("DMT.extraction")' 'raise ImportError' \
      --replace-fail 'pkgutil.find_loader("DMT.hl2")' 'raise ImportError'
  '';

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "DMT.core"
  ];

  meta = {
    changelog = "https://gitlab.com/dmt-development/dmt-core/-/blob/Version_${finalAttrs.version}/CHANGELOG?ref_type=tags";
    description = "Tool to help modeling engineers extract model parameters, run circuit and TCAD simulations and automate infrastructure";
    homepage = "https://gitlab.com/dmt-development/dmt-core";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      jasonodoom
      jleightcap
    ];
    teams = with lib.teams; [ ngi ];
  };
})
