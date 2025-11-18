{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "16.3.0";

  src = fetchFromGitHub {
    owner = "topgrade-rs";
    repo = "topgrade";
    tag = "v${version}";
    hash = "sha256-zvw3YLYe1ffPhoCs8tsIcY0sqNTJW4JZscswtP6a5po=";
  };

  cargoHash = "sha256-dbRIHabvOlrHq/v3kd1dnA/pese3jRYUUKiSXGU3YvY=";

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
    changelog = "https://github.com/topgrade-rs/topgrade/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      SuperSandro2000
      xyenon
    ];
    mainProgram = "topgrade";
  };
}
