{
  lib,
  cmake,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  python3Packages,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "uv";
  version = "0.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    rev = "refs/tags/${version}";
    hash = "sha256-Kieh76RUrDEwdL04mvCXOqbXHasMMpXRqp0LwMOIHdM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-ZhHUKotXVDdwJs2kqIxME5I1FitWetx7FrQtluuIUWo=";
  };

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dontUseCmakeConfigure = true;

  cargoBuildFlags = [
    "--package"
    "uv"
  ];

  postInstall = ''
    export HOME=$TMPDIR
    installShellCompletion --cmd uv \
      --bash <($out/bin/uv --generate-shell-completion bash) \
      --fish <($out/bin/uv --generate-shell-completion fish) \
      --zsh <($out/bin/uv --generate-shell-completion zsh)
  '';

  pythonImportsCheck = [ "uv" ];

  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Extremely fast Python package installer and resolver, written in Rust";
    homepage = "https://github.com/astral-sh/uv";
    changelog = "https://github.com/astral-sh/uv/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "uv";
  };
}
