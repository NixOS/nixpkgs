{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gibberish-detector,
  mock,
  pkgs,
  pyahocorasick,
  pytestCheckHook,
  pyyaml,
  requests,
  responses,
  setuptools,
  unidiff,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "bc-detect-secrets";
  version = "1.5.47";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bridgecrewio";
    repo = "detect-secrets";
    tag = finalAttrs.version;
    hash = "sha256-ykmOa29/ASEr+AG2SjhSUN8gLMeKpscDKsPtTTZ+cU8=";
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
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

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

  meta = {
    description = "Tool to detect secrets in the code";
    homepage = "https://github.com/bridgecrewio/detect-secrets";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
