{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "0.2.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-aws";
    tag = "v${version}";
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
  ];

  nativeCheckInputs = [
    langchain-tests
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_aws" ];

  passthru = {
    inherit (langchain-core) updateScript;
    # updates the wrong fetcher rev attribute
    skipBulkUpdate = true;
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-aws/releases/tag/v${version}";
    description = "Build LangChain application on AWS";
    homepage = "https://github.com/langchain-ai/langchain-aws/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      drupol
      natsukium
    ];
  };
}
