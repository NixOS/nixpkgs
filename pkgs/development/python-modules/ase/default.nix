{
  lib,
  stdenv,
  buildPythonPackage,
  isPy27,
  fetchPypi,
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
  version = "3.25.0";
  pyproject = true;

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N0z4yp/liPBdboVto8nBfvJi3JaAJ7Ix1EkzQUDJYsI=";
  };

  build-system = [ setuptools ];

  dependencies =
    [
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
    # AssertionError: assert (1 != 0) == False
    # TypeError: list indices must be integers or slices, not numpy.bool
    "test_long"

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
  ] ++ lib.optionals (pythonAtLeast "3.12") [ "test_info_calculators" ];

  pythonImportsCheck = [ "ase" ];

  meta = {
    description = "Atomic Simulation Environment";
    homepage = "https://wiki.fysik.dtu.dk/ase/";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
