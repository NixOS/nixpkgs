{
  lib,
  stdenv,
  fetchFromGitLab,
  buildPythonPackage,
  pythonAtLeast,

  # build-system
  setuptools,

  # dependencies
  flask,
  matplotlib,
  numpy,
  pillow,
  psycopg2,
  scipy,
  tkinter,

  # tests
  addBinToPathHook,
  pytestCheckHook,
  pytest-mock,
  pytest-xdist,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "ase";
  version = "3.26.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "ase";
    repo = "ase";
    tag = version;
    hash = "sha256-1738NQPgOqSr2PZu1T2b9bL0V+ZzGk2jcWBhLF21VQs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    matplotlib
    numpy
    pillow
    psycopg2
    scipy
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    tkinter
  ];

  nativeCheckInputs = [
    addBinToPathHook
    pytestCheckHook
    pytest-mock
    pytest-xdist
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    "test_fundamental_params"
    "test_ase_bandstructure"
    "test_imports"
    "test_units"
    "test_favicon"
    "test_vibrations_methods" # missing attribute
    "test_jmol_roundtrip" # missing attribute
    "test_pw_input_write_nested_flat" # Did not raise DeprecationWarning
    "test_fix_scaled" # Did not raise UserWarning
    "test_ipi_protocol" # flaky
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [ "test_info_calculators" ];

  pythonImportsCheck = [ "ase" ];

  meta = {
    description = "Atomic Simulation Environment";
    homepage = "https://ase-lib.org/";
    changelog = "https://ase-lib.org/releasenotes.html";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
