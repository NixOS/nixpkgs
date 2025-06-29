{
  lib,
  stdenv,
  fetchFromGitLab,
  buildPythonPackage,
  isPy27,
  pythonAtLeast,
  setuptools,
  numpy,
  scipy,
  matplotlib,
  flask,
  pillow,
  psycopg2,
  tkinter,
  pytestCheckHook,
  pytest-mock,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "ase";
  version = "3.25.0";
  pyproject = true;

  src = fetchFromGitLab {
    inherit pname version;
    owner = "ase";
    repo = "ase";
    tag = version;
    hash = "sha256-yYFmbZoDemtu0whnExHJ9t+cK7ObWEj3XXijh+/Fx74=";
  };

  build-system = [ setuptools ];

  dependencies =
    [
      numpy
      scipy
      matplotlib
      flask
      pillow
      psycopg2
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      tkinter
    ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pytest-xdist
  ];

  pytestFlagsArray = [
    ''-m "not slow"'' # skip slow tests
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
    "test_long" # fails in sandbox (issue loading Matlib)
  ] ++ lib.optionals (pythonAtLeast "3.12") [ "test_info_calculators" ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
    export MPLCONFIGDIR=$(mktemp -d)
  '';

  pythonImportsCheck = [ "ase" ];

  meta = {
    description = "Atomic Simulation Environment";
    homepage = "https://wiki.fysik.dtu.dk/ase/";
    changelog = "https://wiki.fysik.dtu.dk/ase/releasenotes.html";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
