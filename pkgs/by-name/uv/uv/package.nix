{
  lib,
  stdenv,
  buildPackages,
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
  version = "0.4.30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    rev = "refs/tags/${version}";
    hash = "sha256-xy/fgy3+YvSdfq5ngPVbAmRpYyJH27Cft5QxBwFQumU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-QINf3D4w96WZC7iiinCyMjKHgWXUiXD9/nTgHu54pI0=";
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

  postInstall =
    let
      uv = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/uv";
    in
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      export HOME=$TMPDIR
      installShellCompletion --cmd uv \
        --bash <(${uv} --generate-shell-completion bash) \
        --fish <(${uv} --generate-shell-completion fish) \
        --zsh <(${uv} --generate-shell-completion zsh)
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
