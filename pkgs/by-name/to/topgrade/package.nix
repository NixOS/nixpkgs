{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  llvmPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "topgrade";
  version = "17.7.0";

  src = fetchFromGitHub {
    owner = "topgrade-rs";
    repo = "topgrade";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2oydjlPZLWlGNvahsRK7kG5gxEKEHMDNxteaOeYupPA=";
  };

  cargoHash = "sha256-8pK6ZUlMNcczbmMJvQUsJKp0RoXnimnkbAc7SzrIcJQ=";

  nativeBuildInputs = [
    installShellFiles
  ]
  # TODO: Remove once #536365 reaches this branch
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.lld ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_COMPILE = toString [
      "-framework"
      "AppKit"
    ];
    # TODO: Remove once #536365 reaches this branch
    NIX_CFLAGS_LINK = "-fuse-ld=lld";
  };

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd topgrade \
      --bash <($out/bin/topgrade --gen-completion bash) \
      --fish <($out/bin/topgrade --gen-completion fish) \
      --zsh <($out/bin/topgrade --gen-completion zsh)

    $out/bin/topgrade --gen-manpage > topgrade.8
    installManPage topgrade.8
  '';

  meta = {
    description = "Upgrade all the things";
    homepage = "https://github.com/topgrade-rs/topgrade";
    changelog = "https://github.com/topgrade-rs/topgrade/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      SuperSandro2000
      xyenon
    ];
    mainProgram = "topgrade";
  };
})
