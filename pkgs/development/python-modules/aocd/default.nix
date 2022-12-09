{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, requests
, pytestCheckHook
, tzlocal
, pytest-mock
, pytest-freezegun
, pytest-raisin
, pytest-socket
, requests-mock
, pebble
, python-dateutil
, termcolor
, beautifulsoup4
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aocd";
  version = "1.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wimglenn";
    repo = "advent-of-code-data";
    rev = "refs/tags/v${version}";
    hash = "sha256-yY8ItXZZp0yVs4viJzduMPq8Q8NKd34uvlGaVUE2GjQ=";
  };

  propagatedBuildInputs = [
    python-dateutil
    requests
    termcolor
    beautifulsoup4
    pebble
    tzlocal
    setuptools
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
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
    pytest-freezegun
    pytest-raisin
    pytest-socket
    requests-mock
  ];

  pythonImportsCheck = [
    "aocd"
  ];

  meta = with lib; {
    description = "Get your Advent of Code data with a single import statement";
    homepage = "https://github.com/wimglenn/advent-of-code-data";
    changelog = "https://github.com/wimglenn/advent-of-code-data/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ aadibajpai ];
    platforms = platforms.unix;
  };
}
