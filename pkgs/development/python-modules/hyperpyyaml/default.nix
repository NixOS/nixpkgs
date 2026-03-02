{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pyyaml,
  ruamel-yaml,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hyperpyyaml";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "speechbrain";
    repo = "hyperpyyaml";
    tag = "v${version}";
    hash = "sha256-/7OrIR61zQYl2+RjiOOlaqUGWBieon5fe8sgmEvKowo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyyaml
    ruamel-yaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hyperpyyaml" ];

  meta = {
    # https://github.com/speechbrain/HyperPyYAML/pull/32
    broken = lib.versionAtLeast ruamel-yaml.version "0.19";
    description = "Extensions to YAML syntax for better python interaction";
    homepage = "https://github.com/speechbrain/HyperPyYAML";
    changelog = "https://github.com/speechbrain/HyperPyYAML/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
