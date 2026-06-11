{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "topgrade";
  version = "17.6.1";

  src = fetchFromGitHub {
    owner = "topgrade-rs";
    repo = "topgrade";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JXLLPglpf8X6PlbT55jgQa/XZbbAJlB/HhSxGiS1w0I=";
  };

  cargoHash = "sha256-FRBxo5x0imxh3F0ZBsScdQTirfaGcQ+y5RSy7DmDSmk=";

  nativeBuildInputs = [
    installShellFiles
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-framework"
      "AppKit"
    ]
  );

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
