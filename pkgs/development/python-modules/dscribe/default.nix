{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pybind11,
  setuptools,

  # dependencies
  ase,
  joblib,
  numpy,
  scikit-learn,
  scipy,
  sparse,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dscribe";
  version = "2.1.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "singroup";
    repo = "dscribe";
    tag = "v${version}";
    fetchSubmodules = true; # Bundles a specific version of Eigen
    hash = "sha256-2JY24cR2ie4+4svVWC4rm3Iy6Wfg0n2vkINz032kPWc=";
  };

  build-system = [
    pybind11
    setuptools
  ];

  dependencies = [
    ase
    joblib
    numpy
    scikit-learn
    scipy
    sparse
  ];

  pythonImportsCheck = [
    "dscribe"
    "dscribe.ext"
  ];

  # Prevents python from loading dscribe from the current working directory instead of using $out
  preCheck = ''
    rm -rf dscribe
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # AttributeError: module 'numpy' has no attribute 'product'
    "test_extended_system"
  ]
  ++
    lib.optionals
      ((stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) || stdenv.hostPlatform.isDarwin)
      [
        # AssertionError on a numerical test
        "test_cell_list"
      ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Fatal Python error: Aborted
    # matplotlib/backend_bases.py", line 2654 in create_with_canvas
    "test_examples"
  ];

  # Broken due to use of missing _get_constraints attr in ase >= 3.26.0
  # https://github.com/SINGROUP/dscribe/issues/160
  disabledTestPaths = [
    "tests/test_examples.py::test_examples"
    "tests/test_general.py::test_atoms_to_system"
    "tests/test_lmbtr.py"
    "tests/test_mbtr.py"
    "tests/test_sinematrix.py"
    "tests/test_valle_oganov.py"
  ];

  meta = {
    description = "Machine learning descriptors for atomistic systems";
    homepage = "https://github.com/SINGROUP/dscribe";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sheepforce ];
  };
}
