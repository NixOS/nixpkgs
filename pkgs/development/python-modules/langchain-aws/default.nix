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

  # tests
  langchain-standard-tests,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "langchain-aws";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-aws";
    rev = "refs/tags/v${version}";
    hash = "sha256-P9CfAVpKh7djhUQc3DyyJTWqs9RbrTeLyynLei0x00o=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--snapshot-warn-unused" "" \
      --replace-fail "--cov=langchain_aws" ""
  '';

  sourceRoot = "${src.name}/libs/aws";

  build-system = [ poetry-core ];

  dependencies = [
    boto3
    langchain-core
    numpy
  ];

  nativeCheckInputs = [
    langchain-standard-tests
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_aws" ];

  passthru = {
    inherit (langchain-core) updateScript;
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
