{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  numpy,

  # tests
  beautifulsoup4,
  html5lib,
  jinja2,
  lxml,
  matplotlib,
  odfpy,
  openpyxl,
  pandas,
  pyarrow,
  pyiceberg,
  pyreadstat,
  pytestCheckHook,
  python-calamine,
  scipy,
  sqlalchemy,
  tables,
  tabulate,
  typing-extensions,
  xarray,
  xlsxwriter,
}:

buildPythonPackage (finalAttrs: {
  pname = "pandas-stubs";
  version = "3.0.3.260530";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pandas-dev";
    repo = "pandas-stubs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vPXz4ibNbFE2B14pkGPN5EDAwhA92VgFXzMLR9da6WQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    beautifulsoup4
    html5lib
    jinja2
    lxml
    matplotlib
    odfpy
    openpyxl
    pandas
    pyarrow
    pyiceberg
    pyreadstat
    pytestCheckHook
    python-calamine
    scipy
    sqlalchemy
    tables
    tabulate
    typing-extensions
    xarray
    xlsxwriter
  ];

  pytestFlags = [
    # DeprecationWarning: The 'generic' unit for NumPy timedelta is deprecated, and will raise an error in the future.
    # This includes implicit conversion of bare integers (e.g. `+ 1`).Please use a specific unit instead.
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = [
    # Missing dependencies, error and warning checks
    "test_all_read_without_lxml_dtype_backend" # pyarrow.orc
    "test_orc" # pyarrow.orc
    "test_iceberg" # pyiceberg
    "test_plotting" # UserWarning: No artists with labels found to put in legend.
    "test_spss" # FutureWarning: ChainedAssignmentError: behaviour will change in pandas 3.0!
    "test_show_version"
    # FutureWarning: In the future `np.bool` will be defined as the corresponding...
    "test_timedelta_cmp"
    "test_timestamp_cmp"
    # DeprecationWarning: The 'generic' unit for NumPy timedelta is deprecated
    "test_timedelta_properties_methods"
    "test_sparse_dtype"
    "test_sparse_dtype_fill_value_subtype_compatibility"
    "test_isna"
    "test_timedelta_range"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_clipboard" # FileNotFoundError: [Errno 2] No such file or directory: 'pbcopy'
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # Disable tests for types that are not supported on aarch64 in `numpy` < 2.0
    "test_astype_float" # `f16` and `float128`
    "test_astype_complex" # `c32` and `complex256`
  ];

  pythonImportsCheck = [ "pandas" ];

  meta = {
    description = "Type annotations for Pandas";
    homepage = "https://github.com/pandas-dev/pandas-stubs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malo ];
  };
})
