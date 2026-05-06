{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  aiohttp,
  async-substrate-interface,
  backoff,
  bittensor-drand,
  bittensor-wallet,
  cyscale,
  gitpython,
  jinja2,
  netaddr,
  numpy,
  packaging,
  plotille,
  plotly,
  pycryptodome,
  pyyaml,
  rich,
  typer,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "bittensor-cli";
  version = "9.21.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "latent-to";
    repo = "btcli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S4omNwksE2tvGjdXBBOdFRvy1KcHrWt87o2kWIC8Sz0=";
  };

  build-system = [ flit-core ];

  dependencies = [
    aiohttp
    async-substrate-interface
    backoff
    bittensor-drand
    bittensor-wallet
    cyscale
    gitpython
    jinja2
    netaddr
    numpy
    packaging
    plotille
    plotly
    pycryptodome
    pyyaml
    rich
    typer
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  # e2e tests require a running subtensor node
  disabledTestPaths = [ "tests/e2e_tests" ];

  pythonImportsCheck = [ "bittensor_cli" ];

  meta = {
    description = "Bittensor command line tool";
    homepage = "https://github.com/latent-to/btcli";
    changelog = "https://github.com/latent-to/btcli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kilyanni ];
    mainProgram = "btcli";
  };
})
