{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # native
  poetry-core,

  # propagated
  blessed,
  editor,
  readchar,

  # tests
  pytest-mock,
  pytestCheckHook,
  pexpect,
}:

buildPythonPackage rec {
  pname = "inquirer";
  version = "3.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "magmax";
    repo = "python-inquirer";
    tag = "v${version}";
    hash = "sha256-xVHmdJGN5yOxbEkZIiOLqeUwcfdj+o7jTTWBD75szII=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    blessed
    editor
    readchar
  ];

  nativeCheckInputs = [
    pexpect
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # Blessed 1.40+ XTGETTCAP terminal queries block in pexpect-based PTY tests.
    # https://github.com/jquast/blessed/pull/375
    "test_autocomplete"
    "test_backspace"
    "test_backspace_limit"
    "test_change_selection"
    "test_default_input"
    "test_default_invert_selection_with_ctrl_i"
    "test_default_selection"
    "test_invalid_phone"
    "test_locked_option_left_key"
    "test_locked_option_space"
    "test_locked_with_another_option"
    "test_minimal_input"
    "test_other_blank_input"
    "test_other_input"
    "test_other_select_choice"
    "test_out_of_bounds_down"
    "test_out_of_bounds_up"
    "test_reset_with_ctrl_r"
    "test_select_all_with_ctrl_a"
    "test_select_last"
    "test_select_one_more"
    "test_select_the_third"
    "test_select_with_arrows"
    "test_shortcuts"
    "test_unselect"
    "test_unselect_with_arrows"
  ];

  pythonImportsCheck = [ "inquirer" ];

  meta = {
    description = "Collection of common interactive command line user interfaces, based on Inquirer.js";
    homepage = "https://github.com/magmax/python-inquirer";
    changelog = "https://github.com/magmax/python-inquirer/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mmahut ];
  };
}
