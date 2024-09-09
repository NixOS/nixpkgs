{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
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
  version = "2.2.2.240603";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pandas-dev";
    repo = "pandas-stubs";
    rev = "refs/tags/v${version}";
    hash = "sha256-wJ7lN1+BGNqhwgPLmmpb3foX6rIEy3R62rOvu0mr8xs=";
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

    # missing dependencies in nixpkgs
    # python-calamine
  ];

  disabledTests =
    [
      # Missing dependencies, error and warning checks
      "test_all_read_without_lxml_dtype_backend" # pyarrow.orc
      "test_orc" # pyarrow.orc
      "test_read_excel" # python-calamine
      "test_plotting" # UserWarning: No artists with labels found to put in legend.
      "test_spss" # FutureWarning: ChainedAssignmentError: behaviour will change in pandas 3.0!
      "test_show_version"
    ]
    ++ lib.optionals stdenv.isDarwin [
      "test_clipboard" # FileNotFoundError: [Errno 2] No such file or directory: 'pbcopy'
    ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
      # Disable tests for types that are not supported on aarch64 in `numpy` < 2.0
      "test_astype_float" # `f16` and `float128`
      "test_astype_complex" # `c32` and `complex256`
    ];

  pythonImportsCheck = [ "pandas" ];

  meta = with lib; {
    description = "Type annotations for Pandas";
    homepage = "https://github.com/pandas-dev/pandas-stubs";
    license = licenses.mit;
    maintainers = with maintainers; [ malo ];
  };
}
