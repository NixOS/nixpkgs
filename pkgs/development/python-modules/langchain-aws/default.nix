{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build-system
  poetry-core,

  # dependencies
  boto3,
  langchain-core,
  numpy,
  pydantic,

  # tests
  langchain-tests,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "langchain-aws";
  version = "0.2.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-aws";
    tag = "langchain-aws==${version}";
    hash = "sha256-tEkwa+rpitGxstci754JH5HCqD7+WX0No6ielJJnbxk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--snapshot-warn-unused" "" \
      --replace-fail "--cov=langchain_aws" ""
    substituteInPlace tests/unit_tests/{test_standard.py,chat_models/test_bedrock_converse.py} \
      --replace-fail "langchain_standard_tests" "langchain_tests"
  '';

  sourceRoot = "${src.name}/libs/aws";

  build-system = [ poetry-core ];

  dependencies = [
    boto3
    langchain-core
    numpy
    pydantic
  ];

  pythonRelaxDeps = [
    # Boto @ 1.35 has outstripped the version requirement
    "boto3"
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

  nativeCheckInputs = [
    langchain-tests
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_aws" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "langchain-aws==([0-9.]+)"
    ];
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-aws/releases/tag/v${version}";
    description = "Build LangChain application on AWS";
    homepage = "https://github.com/langchain-ai/langchain-aws/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      drupol
      natsukium
      sarahec
    ];
  };
}
