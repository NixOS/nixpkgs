{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "topgrade";
  version = "17.8.0";

  src = fetchFromGitHub {
    owner = "topgrade-rs";
    repo = "topgrade";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cvyvk7Q9BpNGNDXYwSwUpAqF8RWNGZ3SVKDOzPrjzFs=";
  };

  cargoHash = "sha256-RPYJNcF6TUEH1a0ErcdqOs8RQcnBZu3sTiw6X1d15D8=";

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
