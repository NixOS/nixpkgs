{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gibberish-detector,
  mock,
  pkgs,
  pyahocorasick,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  responses,
  setuptools,
  unidiff,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "bc-detect-secrets";
  version = "1.5.45";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bridgecrewio";
    repo = "detect-secrets";
    tag = version;
    hash = "sha256-/0VHhKcYcXYXosInjsgBf6eR7kcfLiLSyxFuaIqTbiQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    requests
    unidiff
  ];

  optional-dependencies = {
    word_list = [ pyahocorasick ];
    gibberish = [ gibberish-detector ];
  };

  nativeCheckInputs = [
    mock
    pkgs.gitMinimal
    pytestCheckHook
    responses
    writableTmpDirAsHomeHook
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

  pythonImportsCheck = [ "detect_secrets" ];

<<<<<<< HEAD
  meta = {
    description = "Tool to detect secrets in the code";
    homepage = "https://github.com/bridgecrewio/detect-secrets";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Tool to detect secrets in the code";
    homepage = "https://github.com/bridgecrewio/detect-secrets";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
