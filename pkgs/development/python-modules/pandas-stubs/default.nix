{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  numpy,
  types-pytz,

  # tests
  pytestCheckHook,
  beautifulsoup4,
  html5lib,
  jinja2,
  lxml,
  matplotlib,
  odfpy,
  openpyxl,
  pandas,
  pyarrow,
  pyreadstat,
  python-calamine,
  scipy,
  sqlalchemy,
  tables,
  tabulate,
  typing-extensions,
  xarray,
  xlsxwriter,
}:

buildPythonPackage rec {
  pname = "pandas-stubs";
  version = "2.3.2.250827";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pandas-dev";
    repo = "pandas-stubs";
    tag = "v${version}";
    hash = "sha256-qjHnFT/ydK5n6QfUzAhnGJWVpqHQbMoqGkel3Pu7S78=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    numpy
    types-pytz
  ];

  nativeCheckInputs = [
    pytestCheckHook
    beautifulsoup4
    html5lib
    jinja2
    lxml
    matplotlib
    odfpy
    openpyxl
    pandas
    pyarrow
    pyreadstat
    scipy
    sqlalchemy
    tables
    tabulate
    typing-extensions
    xarray
    xlsxwriter
    python-calamine
  ];

  disabledTests = [
    # Missing dependencies, error and warning checks
    "test_all_read_without_lxml_dtype_backend" # pyarrow.orc
    "test_orc" # pyarrow.orc
    "test_plotting" # UserWarning: No artists with labels found to put in legend.
    "test_spss" # FutureWarning: ChainedAssignmentError: behaviour will change in pandas 3.0!
    "test_show_version"
    # FutureWarning: In the future `np.bool` will be defined as the corresponding...
    "test_timedelta_cmp"
    "test_timestamp_cmp"
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
}
