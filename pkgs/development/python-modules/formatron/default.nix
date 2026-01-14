{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  general-sam,
  setuptools,
  kbnf,
  frozendict,
  jsonschema,
  pydantic,
  transformers,
  vllm,
}:
buildPythonPackage rec {
  pname = "formatron";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Dan-wanna-M";
    repo = "formatron";
    rev = "v${version}";
    hash = "sha256-LQJza8F5wPcQO1y7Ino4slv7zoJMsZBn4LKLWYO9818=";
    fetchSubmodules = true;
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    frozendict
    general-sam
    jsonschema
    kbnf
    pydantic
  ];

  optional-dependencies = {
    transformers = [
      transformers
    ];
    vllm = [
      vllm
    ];
  };

  pythonImportsCheck = [
    "formatron"
  ];

  meta = {
    description = "Control the output format of language models";
    homepage = "https://github.com/Dan-wanna-M/formatron";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ BatteredBunny ];
  };
}
