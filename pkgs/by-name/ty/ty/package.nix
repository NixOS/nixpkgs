{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  installShellFiles,

  buildPackages,
}:

rustPlatform.buildRustPackage rec {
  pname = "ty";
  version = "0.0.1-alpha.1";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    rev = "f8890b70c35b2d05a8fa21958077de2aab5ba2ad";
    hash = "sha256-5kkUYa7fwGf+X11W//XXsEAna8fiNcl3bhALOiXjnHQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-zKy2hlU3Buy+SzN1lNEXb/7V6VlhbGOc78nz1/Ruk+0=";

  nativeBuildInputs = [
    installShellFiles
  ];

  dontUseCmakeConfigure = true;

  cargoBuildFlags = [
    "--package"
    "ty"
  ];

  # Tests require python3
  doCheck = false;

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd ty \
        --bash <(${emulator} $out/bin/ty generate-shell-completion bash) \
        --fish <(${emulator} $out/bin/ty generate-shell-completion fish) \
        --zsh <(${emulator} $out/bin/ty generate-shell-completion zsh)
    '';

  doInstallCheck = true;

  meta = {
    description = "Extremely fast Python type checker and language server, written in Rust.";
    homepage = "https://github.com/astral-sh/ty";
    changelog = "https://github.com/astral-sh/ty/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
    ];
    maintainers = with lib.maintainers; [ ryantm ];
    mainProgram = "ty";
  };
}
