{
  lib,
  stdenv,
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,

  # build-system
  setuptools,

  # nativeBuildInputs
  cython,
  glibcLocales,

  # dependencies
  bibtexparser,
  joblib,
  matplotlib,
  monty,
  networkx,
  numpy,
  orjson,
  palettable,
  pandas,
  plotly,
  pybtex,
  requests,
  ruamel-yaml,
  scipy,
  spglib,
  sympy,
  tabulate,
  tqdm,
  uncertainties,

  # optional-dependencies
  netcdf4,
  ase,
  pytest,
  pytest-cov,
  invoke,
  sphinx,
  sphinx-rtd-theme,
  numba,
  vtk,

  # tests
  addBinToPathHook,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2025.6.14";
  pyproject = true;

  disabled = pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "materialsproject";
    repo = "pymatgen";
    tag = "v${version}";
    hash = "sha256-HMYYhXT5k/EjG1sIBq/53K9ogeSk8ZEJQBrDHCgz+SA=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    cython
    glibcLocales
  ];

  dependencies = [
    bibtexparser
    joblib
    matplotlib
    monty
    networkx
    numpy
    orjson
    palettable
    pandas
    plotly
    pybtex
    requests
    ruamel-yaml
    scipy
    spglib
    sympy
    tabulate
    tqdm
    uncertainties
  ];

  optional-dependencies = {
    abinit = [ netcdf4 ];
    ase = [ ase ];
    ci = [
      pytest
      pytest-cov
      # pytest-split
    ];
    docs = [
      invoke
      sphinx
      # sphinx_markdown_builder
      sphinx-rtd-theme
    ];
    electronic_structure = [
      # fdint
    ];
    mlp = [
      # chgnet
      # matgl
    ];
    numba = [ numba ];
    vis = [ vtk ];
  };

  pythonImportsCheck = [ "pymatgen" ];

  pytestFlagsArray = [
    # We have not packaged moyopy yet.
    "--deselect=tests/analysis/test_prototypes.py::test_get_protostructure_label_from_moyopy"
  ];

  nativeCheckInputs = [
    addBinToPathHook
    pytestCheckHook
    pytest-xdist
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck =
    # ensure tests can find these
    ''
      export PMG_TEST_FILES_DIR="$(realpath ./tests/files)"
    '';

  disabledTests =
    [
      # Flaky
      "test_numerical_eos_values"
      "test_pca"
      "test_static_si_no_kgrid"
      "test_thermal_conductivity"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # AttributeError: 'NoneType' object has no attribute 'items'
      "test_mean_field"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Fatal Python error: Aborted
      # matplotlib/backend_bases.py", line 2654 in create_with_canvas
      "test_angle"
      "test_as_dict_from_dict"
      "test_attributes"
      "test_basic"
      "test_core_state_eigen"
      "test_eos_func"
      "test_get_info_cohps_to_neighbors"
      "test_get_plot"
      "test_get_point_group_operations"
      "test_matplotlib_plots"
      "test_ph_plot_w_gruneisen"
      "test_plot"
      "test_proj_bandstructure_plot"
      "test_structure"
      "test_structure_environments"

      # attempt to insert nil object from objects[1]
      "test_timer_10_2_7"
    ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # Crash when running the pmg command
    # Critical error: required built-in appearance SystemAppearance not found
    "tests/cli/test_pmg_plot.py"
  ];

  meta = {
    description = "Robust materials analysis code that defines core object representations for structures and molecules";
    homepage = "https://pymatgen.org/";
    changelog = "https://github.com/materialsproject/pymatgen/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psyanticy ];
  };
}
