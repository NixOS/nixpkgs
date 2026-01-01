{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
<<<<<<< HEAD
  version = "16.7.0";
=======
  version = "16.5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "topgrade-rs";
    repo = "topgrade";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-1RbOb8YW17g+iqd/jbN5fZBBJmUgvefrm+b8zwpvMJg=";
  };

  cargoHash = "sha256-naObSjHmUpx6JyjLt16xT+c4qeCtRDkJhSdcgIA8pBU=";
=======
    hash = "sha256-2Cj3o2ybNA7ss3fyPaDXtQxIl2fXuxfY7SZI5K/Q2tc=";
  };

  cargoHash = "sha256-eXRWR5EvjqYQSY9hzb31iladS699Oy+n/dojid9BBFU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
