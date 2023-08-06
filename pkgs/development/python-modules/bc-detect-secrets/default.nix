{ lib
, buildPythonPackage
, fetchFromGitHub
, gibberish-detector
, mock
, pkgs
, pyahocorasick
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, responses
, unidiff
}:

buildPythonPackage rec {
  pname = "bc-detect-secrets";
  version = "1.4.30";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bridgecrewio";
    repo = "detect-secrets";
    rev = "refs/tags/${version}";
    hash = "sha256-wq+SKOiMcVO7OiK+RdRk4RNsjSAT7lBdAjLHfurSIRo=";
  };

  propagatedBuildInputs = [
    pyyaml
    requests
    unidiff
  ];

  passthru.optional-dependencies = {
    word_list = [
      pyahocorasick
    ];
    gibberish = [
      gibberish-detector
    ];
  };

  nativeCheckInputs = [
    mock
    pkgs.gitMinimal
    pytestCheckHook
    responses
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # Tests are failing for various reasons (missing git repo, missing test data, etc.)
    "test_baseline_filters_out_known_secrets"
    "test_make_decisions"
    "test_saves_to_baseline"
    "test_start_halfway"
    "TestCreate"
    "TestDiff"
    "TestGetFilesToScan"
    "TestLineNumberChanges"
    "TestModifiesBaselineFromVersionChange"
  ];

  pythonImportsCheck = [
    "detect_secrets"
  ];

  meta = with lib; {
    description = "Tool to detect secrets in the code";
    homepage = "https://github.com/bridgecrewio/detect-secrets";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

