{
  lib,
  aocd-example-parser,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pebble,
  pook,
  pytest-freezegun,
  pytest-mock,
  pytest-raisin,
  pytest-socket,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  requests,
  requests-mock,
  rich,
  setuptools,
  termcolor,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "aocd";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "wimglenn";
    repo = "advent-of-code-data";
    rev = "refs/tags/v${version}";
    hash = "sha256-YZvcR97uHceloqwoP+azaBmj3GLusYNbItLIaeJ3QD0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aocd-example-parser
    beautifulsoup4
    pebble
    python-dateutil
    requests
    rich # for example parser aoce. must either be here or checkInputs
    termcolor
    tzlocal
  ];

  nativeCheckInputs = [
    numpy
    pook
    pytest-freezegun
    pytest-mock
    pytest-raisin
    pytest-socket
    pytestCheckHook
    requests-mock
  ];

  # Too many failing tests
  preCheck = "rm pytest.ini";

  disabledTests = [
    "test_results"
    "test_results_xmas"
    "test_run_error"
    "test_run_and_autosubmit"
    "test_run_and_no_autosubmit"
    "test_load_input_from_file"
    "test_examples_cache" # IndexError: list index out of range
    "test_example_partial" # ValueError: not enough values to unpack (expected 1, got 0)
    "test_run_against_examples" # AssertionError: assert '2022/25 - The Puzzle Title' in ''
    "test_aocd_no_examples" # SystemExit: 2
    "test_aocd_examples" # SystemExit: 2
    "test_aoce" # SystemExit: 1

    # TypeError: sequence item 0: expected str instance, bool found
    # Likely because they use `pook.get` to get a webpage
    "test_submit_prevents_bad_guesses_too_high"
    "test_submit_prevents_bad_guesses_too_low"
    "test_submit_prevents_bad_guesses_known_incorrect"
    "test_submit_correct_answer"
    "test_correct_submit_reopens_browser_on_answer_page"
    "test_server_error"
    "test_submit_when_already_solved"
    "test_submitted_too_recently_autoretry"
    "test_submitted_too_recently_autoretry_quiet"
    "test_submit_when_submitted_too_recently_no_autoretry"
    "test_submit_wrong_answer "
    "test_correct_submit_records_good_answer"
    "test_submits_for_partb_when_already_submitted_parta"
    "test_submit_when_parta_solved_but_answer_unsaved"
    "test_submit_saves_both_answers_if_possible"
    "test_submit_puts_level1_by_default"
    "test_cannot_submit_same_bad_answer_twice"
    "test_submit_float_warns"
  ];

  pythonImportsCheck = [ "aocd" ];

  meta = with lib; {
    description = "Get your Advent of Code data with a single import statement";
    homepage = "https://github.com/wimglenn/advent-of-code-data";
    changelog = "https://github.com/wimglenn/advent-of-code-data/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ aadibajpai ];
    platforms = platforms.unix;
  };
}
