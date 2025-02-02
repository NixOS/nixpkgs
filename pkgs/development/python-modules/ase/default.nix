{
  lib,
  stdenv,
  fetchPypi,
  fetchpatch2,
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
  version = "3.23.0";
  pyproject = true;

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kaKqMdib2QsO/f5KfoQmTzKCiyq/yfOOZeBBrXb+yK4=";
  };

  patches = [
    # https://gitlab.com/ase/ase/-/merge_requests/3400
    (fetchpatch2 {
      name = "numpy_2-compatibility.patch";
      url = "https://gitlab.com/ase/ase/-/commit/5434193ad9dd2cb20a76b3d503fa2b50d7a8ed34.patch";
      excludes = [ "pyproject.toml" ];
      hash = "sha256-3hsyzYnFCrlZDT/jqJKKvj2UXjnjLU0U6PJqgOpA7CU=";
    })
  ];

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
