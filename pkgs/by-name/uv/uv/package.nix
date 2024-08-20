{
  lib,
  cmake,
  darwin,
  fetchFromGitHub,
  installShellFiles,
  libiconv,
  pkg-config,
  python3Packages,
  rustPlatform,
  stdenv,
  testers,
  uv,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "uv";
  version = "0.2.37";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    rev = "refs/tags/${version}";
    hash = "sha256-3FSA+JsAbLzS3ONoLciDzpyCsO6Em8lNVYR43WiK1xs=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "async_zip-0.0.17" = "sha256-3k9rc4yHWhqsCUJ17K55F8aQoCKdVamrWAn6IDWo3Ss=";
      "pubgrub-0.2.1" = "sha256-yhZm35Dyl6gcBTxKvsxJXv1GTOuMCDknnSTgGgKD488=";
      "reqwest-middleware-0.3.2" = "sha256-OiC8Kg+F2eKy7YNuLtgYPi95DrbxLvsIKrKEeyuzQTo=";
    };
  };

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [
    libiconv
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

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

  passthru = {
    tests.version = testers.testVersion { package = uv; };
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
