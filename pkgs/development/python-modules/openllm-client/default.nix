{
  lib,
  buildPythonPackage,
  pythonOlder,
  bentoml,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  anyio,
  distro,
  httpx,
  httpx-auth,
  openllm-core,
  soundfile,
  transformers,
}:

buildPythonPackage rec {
  inherit (openllm-core) src version;
  pname = "openllm-client";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${src.name}/openllm-client";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling==1.18.0" "hatchling" \
      --replace-fail "hatch-vcs==0.3.0" "hatch-vcs" \
      --replace-fail "hatch-fancy-pypi-readme==23.1.0" "hatch-fancy-pypi-readme"
  '';

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  dependencies = [
    anyio
    distro
    httpx
    openllm-core
  ];

  optional-dependencies = {
    grpc = [ bentoml ] ++ bentoml.optional-dependencies.grpc;
    auth = [ httpx-auth ];
    agents = [
      transformers
      # diffusers
      soundfile
    ] ++ transformers.optional-dependencies.agents;
    full = optional-dependencies.grpc ++ optional-dependencies.agents;
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
