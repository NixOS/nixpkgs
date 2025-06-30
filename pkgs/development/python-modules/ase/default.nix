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
  version = "3.25.0-unstable-2025-06-24";
  pyproject = true;

  disabled = isPy27;

  src = fetchFromGitLab {
    owner = "ase";
    repo = "ase";
    rev = "4e22dabfbe7ae2329e50260ca1b6f08a83527ac3";
    hash = "sha256-ehMyVtPxfTxT8T418VyLGnUEyYip4LPTTaGL0va7qgM=";
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
  ] ++ lib.optionals (pythonAtLeast "3.12") [ "test_info_calculators" ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  pythonImportsCheck = [ "ase" ];

  meta = with lib; {
    description = "Atomic Simulation Environment";
    homepage = "https://wiki.fysik.dtu.dk/ase/";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
