{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildPythonPackage,
  installShellFiles,
  pytestCheckHook,
  babel,
  curl-cffi,
  hatchling,
  httpx,
  plotext,
  pydantic,
  python-dotenv,
  ratelimit,
  stdenv,
  tenacity,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "flights";
  version = "0.8.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "punitarani";
    repo = "fli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-57eAtCUXuFmOizLPliI5YVj9ZHJPL7AzxpFAU6K2lDs=";
  };

  patches = [
    # Fix regression in shell completion generation.
    (fetchpatch {
      # This commit has been submitted in a PR to the upstream repo: https://github.com/punitarani/fli/pull/130.
      url = "https://github.com/punitarani/fli/commit/54af7b4f8bcbc85464383d525947e103ad3a7ec7.patch";
      hash = "sha256-8NNRg/COpm0VURwKQZU87trarrfBgX21+TXexKdPLzM=";
    })
  ];

  build-system = [
    hatchling
  ];

  dependencies = [
    babel
    curl-cffi
    httpx
    plotext
    pydantic
    python-dotenv
    ratelimit
    tenacity
    typer
  ];

  pythonImportsCheck = [ "fli" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    lib.optionalString
      (
        # Required to avoid breaking cross builds
        (stdenv.buildPlatform.canExecute stdenv.hostPlatform)

        # Shell  not supported.
        # ERROR: installShellCompletion: installShellCompletion: installed shell completion file `/nix/store/...-python3.14-flights-0.8.4/share/bash-completion/completions/fli.bash' does not exist or has zero size
        || stdenv.hostPlatform.isDarwin
      )
      ''
        installShellCompletion --cmd fli \
          --bash <($out/bin/fli --show-completion bash) \
          --fish <($out/bin/fli --show-completion fish) \
          --zsh <($out/bin/fli --show-completion zsh)
      '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Tests under tests/mcp require fastmcp v3, which nixpkgs does not yet have.
    "tests/mcp"
    # Tests under tests/search execute real searches and require the network.
    "tests/search"
  ];

  meta = {
    description = "Google Flights MCP and Python Library";
    homepage = "https://github.com/punitarani/fli";
    changelog = "https://github.com/punitarani/fli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ squat ];
    mainProgram = "fli";
  };
})
