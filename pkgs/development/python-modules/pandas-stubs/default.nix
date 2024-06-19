{
  lib,
  stdenv,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  html5lib,
  jinja2,
  lxml,
  matplotlib,
  odfpy,
  openpyxl,
  pandas,
  poetry-core,
  pyarrow,
  pyreadstat,
  pytestCheckHook,
  pythonOlder,
  scipy,
  sqlalchemy,
  tables,
  tabulate,
  types-pytz,
  typing-extensions,
  xarray,
  xlsxwriter,
}:

buildPythonPackage rec {
  pname = "pandas-stubs";
  version = "2.2.0.240218";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pandas-dev";
    repo = "pandas-stubs";
    rev = "refs/tags/v${version}";
    hash = "sha256-416vyaHcSfTfkSNKZ05edozfsMmNKcpOZAoPenCLFzQ=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    pandas
    types-pytz
  ];

  nativeCheckInputs = [
    beautifulsoup4
    html5lib
    jinja2
    lxml
    matplotlib
    odfpy
    openpyxl
    pyarrow
    pyreadstat
    pytestCheckHook
    scipy
    sqlalchemy
    tables
    tabulate
    typing-extensions
    xarray
    xlsxwriter
  ];

  disabledTests =
    [
      # AttributeErrors, missing dependencies, error and warning checks
      "test_types_groupby"
      "test_frame_groupby_resample"
      "test_orc"
      "test_all_read_without_lxml_dtype_backend"
      "test_show_version"
    ]
    ++ lib.optionals stdenv.isDarwin [
      "test_plotting" # Fatal Python error: Illegal instruction
    ];

  pythonImportsCheck = [ "pandas" ];

  meta = with lib; {
    description = "Type annotations for Pandas";
    homepage = "https://github.com/pandas-dev/pandas-stubs";
    license = licenses.mit;
    maintainers = with maintainers; [ malo ];
  };
}
