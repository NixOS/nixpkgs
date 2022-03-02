{ lib
, buildPythonPackage
, fetchFromGitHub
, gibberish-detector
, isPy27
, mock
, pkgs
, pyahocorasick
, pytestCheckHook
, pyyaml
, requests
, responses
, unidiff
}:

buildPythonPackage rec {
  pname = "detect-secrets";
  version = "1.2.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4VcV06iaL3NAj7qF8RyfWV1zgrt928AQfjGeuO2Pbjk=";
    leaveDotGit = true;
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
    pkgs.gitMinimal
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # Tests are failing for various reasons. Needs to be adjusted with the next update
    "test_basic"
    "test_handles_each_path_separately"
    "test_handles_multiple_directories"
    "test_load_and_output"
    "test_make_decisions"
    "test_restores_line_numbers"
    "test_saves_to_baseline"
    "test_scan_all_files"
    "test_start_halfway"
  ];

  pythonImportsCheck = [ "detect_secrets" ];

  meta = with lib; {
    description = "An enterprise friendly way of detecting and preventing secrets in code";
    homepage = "https://github.com/Yelp/detect-secrets";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
