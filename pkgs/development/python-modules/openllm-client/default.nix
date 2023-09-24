{ lib
, buildPythonPackage
, pythonOlder
, bentoml
, hatch-fancy-pypi-readme
, hatch-vcs
, hatchling
, httpx
, openllm-core
, soundfile
, transformers
}:

buildPythonPackage rec {
  inherit (openllm-core) src version;
  pname = "openllm-client";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  sourceRoot = "source/openllm-client";

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    httpx
    openllm-core
  ];

  passthru.optional-dependencies = {
    grpc = [
      bentoml
    ] ++ bentoml.optional-dependencies.grpc;
    agents = [
      transformers
      # diffusers
      soundfile
    ] ++ transformers.agents;
    full = passthru.optional-dependencies.grpc ++ passthru.optional-dependencies.agents;
  };

  # there is no tests
  doCheck = false;

  pythonImportsCheck = [ "openllm_client" ];

  meta = with lib; {
    description = "Interacting with OpenLLM HTTP/gRPC server, or any BentoML server";
    homepage = "https://github.com/bentoml/OpenLLM/tree/main/openllm-client";
    changelog = "https://github.com/bentoml/OpenLLM/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}
