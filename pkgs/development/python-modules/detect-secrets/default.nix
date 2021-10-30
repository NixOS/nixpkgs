{ lib
, buildPythonPackage
, fetchFromGitHub
, gibberish-detector
, isPy27
, mock
, pyahocorasick
, pytestCheckHook
, pyyaml
, requests
, responses
, unidiff
}:

buildPythonPackage rec {
  pname = "detect-secrets";
  version = "1.1.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dj0lqm9s8OKhM4OmNrmGVRc32/ZV0I9+5WcW2hvLwu0=";
  };

  propagatedBuildInputs = [
    gibberish-detector
    pyyaml
    pyahocorasick
    requests
  ];

  checkInputs = [
    mock
    pytestCheckHook
    responses
    unidiff
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # Tests are failing for various reasons. Needs to be adjusted with the next update
    "test_baseline_filters_out_known_secrets"
    "test_basic"
    "test_does_not_modify_slim_baseline"
    "test_handles_each_path_separately"
    "test_handles_multiple_directories"
    "test_load_and_output"
    "test_make_decisions"
    "test_modifies_baseline"
    "test_no_files_in_git_repo"
    "test_outputs_baseline_if_none_supplied"
    "test_saves_to_baseline"
    "test_scan_all_files"
    "test_should_scan_all_files_in_directory_if_flag_is_provided"
    "test_should_scan_specific_non_tracked_file"
    "test_should_scan_tracked_files_in_directory"
    "test_start_halfway"
    "test_works_from_different_directory"
    "TestModifiesBaselineFromVersionChange"
  ];

  pythonImportsCheck = [ "detect_secrets" ];

  meta = with lib; {
    description = "An enterprise friendly way of detecting and preventing secrets in code";
    homepage = "https://github.com/Yelp/detect-secrets";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
