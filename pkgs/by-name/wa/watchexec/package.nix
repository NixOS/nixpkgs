{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  llvmPackages,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "watchexec";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "watchexec";
    repo = "watchexec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Dobb+l24nL01od+KET3PGgDzFaYr1LPhkPrbpA3G6y4=";
  };

  cargoHash = "sha256-ZwF5nNI2ESwgaH129MhcJPlhtmxqwhhQ9W49u9bilRk=";

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # TODO: Remove once #536365 reaches this branch
    llvmPackages.lld
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = toString [
      "-framework"
      "AppKit"
    ];
    # TODO: Remove once #536365 reaches this branch
    NIX_CFLAGS_LINK = "-fuse-ld=lld";
  };

  checkFlags = [
    "--skip=help"
    "--skip=help_short"
  ];

  postPatch = ''
    rm .cargo/config.toml
  '';

  postInstall = ''
    installManPage doc/watchexec.1
    installShellCompletion --cmd watchexec \
      --bash completions/bash \
      --fish completions/fish \
      --zsh completions/zsh
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v(.+)"
    ];
  };

  meta = {
    description = "Executes commands in response to file modifications";
    homepage = "https://watchexec.github.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      michalrus
      prince213
    ];
    mainProgram = "watchexec";
  };
})
