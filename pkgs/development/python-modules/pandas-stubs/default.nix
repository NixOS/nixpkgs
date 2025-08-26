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
  python-calamine,
  scipy,
  sqlalchemy,
  tables,
  tabulate,
  typing-extensions,
  xarray,
  xlsxwriter,
}:

buildPythonPackage {
  pname = "pandas-stubs";
  version = "2.3.0.250703-unstable-2025-08-25";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pandas-dev";
    repo = "pandas-stubs";
    rev = "3033eea474b754f7deabfa25a3377ed1efb85c15";
    hash = "sha256-1RU18pP3rmKoemwk44B3RG0D5jiNkx2fxxcXwMBEngY=";
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

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # FileNotFoundError: [Errno 2] No such file or directory: 'pbcopy'
    "test_clipboard"
    "test_all_read_without_lxml_dtype_backend"
  ];

  pythonImportsCheck = [ "pandas" ];

  meta = {
    description = "Type annotations for Pandas";
    homepage = "https://github.com/pandas-dev/pandas-stubs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malo ];
  };
}
