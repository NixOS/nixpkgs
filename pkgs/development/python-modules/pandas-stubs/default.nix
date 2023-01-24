{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, jinja2
, matplotlib
, openpyxl
, pandas
, poetry-core
, scipy
, sqlalchemy
, tabulate
, pyarrow
, pyreadstat
, tables
, pytestCheckHook
, pythonOlder
, types-pytz
, typing-extensions
, xarray
}:

buildPythonPackage rec {
  pname = "pandas-stubs";
  version = "1.5.0.221003";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pandas-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RV0pOTPtlwBmYs3nu8+lNwVpl/VC/VzcXKOQMg9C3qk=";
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
    openpyxl
    scipy
    sqlalchemy
    tabulate
    pyarrow
    tables
    pyreadstat
    pytestCheckHook
    typing-extensions
    xarray
  ];

  disabledTests = [
    # AttributeErrors, missing dependencies, error and warning checks
    "test_data_error"
    "test_specification_error"
    "test_setting_with_copy_error"
    "test_setting_with_copy_warning"
    "test_numexpr_clobbering_error"
    "test_undefined_variable_error"
    "test_indexing_error"
    "test_pyperclip_exception"
    "test_css_warning"
    "test_possible_data_loss_error"
    "test_closed_file_error"
    "test_incompatibility_warning"
    "test_attribute_conflict_warning"
    "test_database_error"
    "test_possible_precision_loss"
    "test_value_label_type_mismatch"
    "test_invalid_column_name"
    "test_categorical_conversion_warning"
    "test_join"
    "test_isetframe"
    "test_reset_index_150_changes"
    "test_compare_150_changes"
    "test_quantile_150_changes"
    "test_resample_150_changes"
    "test_index_astype"
    "test_orc"
    "test_orc_path"
    "test_orc_buffer"
    "test_orc_columns"
    "test_orc_bytes"
    "test_clipboard"
    "test_clipboard_iterator"
    "test_arrow_dtype"
    "test_aggregate_series_combinations"
    "test_aggregate_frame_combinations"
    "test_types_rank"
    "test_reset_index"
    "test_types_assert_series_equal"
    "test_show_version"
    "test_dummies"
    "test_from_dummies_args"
    "test_rolling_step_method"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_plotting" # Fatal Python error: Illegal instruction
  ];

  pythonImportsCheck = [
    "pandas"
  ];

  meta = with lib; {
    description = "Type annotations for Pandas";
    homepage = "https://github.com/VirtusLab/pandas-stubs";
    license = licenses.mit;
    maintainers = with maintainers; [ malo ];
  };
}
