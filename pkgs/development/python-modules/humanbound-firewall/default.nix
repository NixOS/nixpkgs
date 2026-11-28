{
  lib,
  anthropic,
  buildPythonPackage,
  fetchFromGitHub,
  google-generativeai,
  langchain,
  nix-update-script,
  numpy,
  openai,
  protobuf,
  pydantic,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  pyyaml,
  requests,
  sentencepiece,
  setuptools,
  torch,
  transformers,
}:

buildPythonPackage (finalAttrs: {
  pname = "humanbound-firewall";
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "humanbound";
    repo = "humanbound-firewall";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ss2f2PZb4AFhvOdi/8+adTv1L52sCIPWiOo7NTLZWus=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pydantic
    pyyaml
    requests
  ];

  optional-dependencies = {
    all = [
      anthropic
      google-generativeai
      openai
      protobuf
      sentencepiece
      torch
      transformers
    ];
    anthropic = [ anthropic ];
    gemini = [ google-generativeai ];
    openai = [ openai ];
    tier1 = [
      protobuf
      sentencepiece
      torch
      transformers
    ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "humanbound_firewall" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-tier firewall for AI agents";
    homepage = "https://github.com/humanbound/humanbound-firewall";
    changelog = "https://github.com/humanbound/humanbound-firewall/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
