{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, jinja2
, matplotlib
, odfpy
, openpyxl
, pandas
, poetry-core
, pyarrow
, pyreadstat
, pytestCheckHook
, pythonOlder
, scipy
, sqlalchemy
, tables
, tabulate
, types-pytz
, typing-extensions
, xarray
, xlsxwriter
}:

buildPythonPackage rec {
  pname = "pandas-stubs";
  version = "2.0.3.230814";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pandas-dev";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-V/igL+vPJADOL7LwBJljqs2a1BB3vDVYTWXIkK/ImYY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pandas
    types-pytz
  ];

  nativeCheckInputs = [
    jinja2
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

  disabledTests = [
    # AttributeErrors, missing dependencies, error and warning checks
    "test_aggregate_frame_combinations"
    "test_aggregate_series_combinations"
    "test_all_read_without_lxml_dtype_backend"
    "test_arrow_dtype"
    "test_attribute_conflict_warning"
    "test_categorical_conversion_warning"
    "test_clipboard_iterator"
    "test_clipboard"
    "test_closed_file_error"
    "test_compare_150_changes"
    "test_crosstab_args"
    "test_css_warning"
    "test_data_error"
    "test_database_error"
    "test_dummies"
    "test_from_dummies_args"
    "test_hdf_context_manager"
    "test_hdfstore"
    "test_incompatibility_warning"
    "test_index_astype"
    "test_indexing_error"
    "test_invalid_column_name"
    "test_isetframe"
    "test_join"
    "test_numexpr_clobbering_error"
    "test_orc_buffer"
    "test_orc_bytes"
    "test_orc_columns"
    "test_orc_path"
    "test_orc"
    "test_possible_data_loss_error"
    "test_possible_precision_loss"
    "test_pyperclip_exception"
    "test_quantile_150_changes"
    "test_read_hdf_iterator"
    "test_read_sql_via_sqlalchemy_connection"
    "test_read_sql_via_sqlalchemy_engine"
    "test_resample_150_changes"
    "test_reset_index_150_changes"
    "test_reset_index"
    "test_rolling_step_method"
    "test_setting_with_copy_error"
    "test_setting_with_copy_warning"
    "test_show_version"
    "test_specification_error"
    "test_types_assert_series_equal"
    "test_types_rank"
    "test_undefined_variable_error"
    "test_value_label_type_mismatch"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_plotting" # Fatal Python error: Illegal instruction
  ];

  pythonImportsCheck = [
    "pandas"
  ];

  meta = with lib; {
    description = "Type annotations for Pandas";
    homepage = "https://github.com/pandas-dev/pandas-stubs";
    license = licenses.mit;
    maintainers = with maintainers; [ malo ];
  };
}
