{
  lib,
  buildPythonPackage,
  diskcache-community,
  fetchFromGitHub,
  jinja2,
  jq,
  packaging,
  google-re2,
  poetry-core,
  pyparsing,
  pytestCheckHook,
  pyyaml,
  requests,
  types-pyyaml,
  typing-extensions,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysigma";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jg2ESiZCCsA1JJZPypCARgU/7U8cm0wnofZyb1QLVfM=";
  };

  pythonRelaxDeps = [ "types-pyyaml" ];

  build-system = [ poetry-core ];

  dependencies = [
    diskcache-community
    jinja2
    jq
    google-re2
    packaging
    pyparsing
    pyyaml
    requests
    typing-extensions
    types-pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Tests require network connection
    "test_sigma_plugin_directory_default"
    "test_sigma_plugin_directory_get_plugins_compatible"
    "test_sigma_plugin_find_compatible_version"
    "test_sigma_plugin_installation"
    "test_sigma_plugin_pysigma_version_from_pypi"
    "test_sigma_plugin_version_compatible"
    "test_validator_valid_attack_tags_online"
    "test_validator_valid_d3fend_tags_online"
  ];

  pythonImportsCheck = [ "sigma" ];

  meta = {
    description = "Library to parse and convert Sigma rules into queries";
    homepage = "https://github.com/SigmaHQ/pySigma";
    changelog = "https://github.com/SigmaHQ/pySigma/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
