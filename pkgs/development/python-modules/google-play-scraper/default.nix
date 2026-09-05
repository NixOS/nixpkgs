{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "google-play-scraper";
  version = "0-unstable-2024-06-07"; # commit message states version 1.2.7
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JoMingyu";
    repo = "google-play-scraper";
    rev = "ce1df6d67e6d8c39826daac2f668808fc025f284";
    hash = "sha256-6JUizAU0FEw4z5rZfJREAfZn2dBKakXYsCWFXm0iEhs=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ poetry-core ];

  pythonImportsCheck = [ "google_play_scraper" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # requires internet connection to google play
  disabledTests = [
    "test_e2e_scenario_1"
    "test_e2e_scenario_2"
    "test_e2e_scenario_3"
    "test_e2e_scenario_4"
    "test_e2e_scenario_5"
    "test_reply_data_all_types"
    "test_reply_data_only_other_type"
    "test_continuation_token"
    "test_continuation_token_preserves_argument_info"
    "test_reply_data"
    "test_score_filter"
    "test_sort_by_most_relevant"
    "test_sort_by_newest"
    "test_request_multiple_times"
    "test_request_once"
  ];

  meta = {
    description = "Google play scraper for Python inspired by <facundoolano/google-play-scraper>";
    homepage = "https://github.com/JoMingyu/google-play-scraper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
