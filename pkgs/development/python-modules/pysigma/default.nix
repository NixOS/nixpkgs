{
  lib,
  buildPythonPackage,
  diskcache-stubs,
  diskcache,
  fetchFromGitHub,
  jinja2,
  packaging,
  poetry-core,
  pyparsing,
  pytestCheckHook,
  pyyaml,
  requests,
  types-pyyaml,
  typing-extensions,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "pysigma";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma";
    tag = "v${version}";
    hash = "sha256-s/czHIwQzcDvK6PBEFflYnT0S97qDUoYiH5ZPlnhMGE=";
  };

  pythonRelaxDeps = [
    "diskcache-stubs"
    "jinja2"
    "packaging"
    "pyparsing"
    "types-pyyaml"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    diskcache
    diskcache-stubs
    jinja2
    packaging
    pyparsing
    pyyaml
    requests
    types-pyyaml
    typing-extensions
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
    changelog = "https://github.com/SigmaHQ/pySigma/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
