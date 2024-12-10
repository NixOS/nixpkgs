{
  rustPlatform,
  fetchFromGitHub,
  lib,

  installShellFiles,
  stdenv,
  Foundation,
  rust-jemalloc-sys,

  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "yazi";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "sxyazi";
    repo = "yazi";
    rev = "v${version}";
    hash = "sha256-RwkgJX4naD3t97ce4Zg/VWJ41QiVFFqDW5nHpyMtISY=";
  };

  cargoHash = "sha256-qnbinuTuaPiD7ib3aCJzSwuA4s3naFzi+txqX7jkHIo=";

  env.YAZI_GEN_COMPLETIONS = true;

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ rust-jemalloc-sys ] ++ lib.optionals stdenv.isDarwin [ Foundation ];

  postInstall = ''
    installShellCompletion --cmd yazi \
      --bash ./yazi-boot/completions/yazi.bash \
      --fish ./yazi-boot/completions/yazi.fish \
      --zsh  ./yazi-boot/completions/_yazi

    install -Dm444 assets/yazi.desktop -t $out/share/applications
    install -Dm444 assets/logo.png $out/share/pixmaps/yazi.png
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Blazing fast terminal file manager written in Rust, based on async I/O";
    homepage = "https://github.com/sxyazi/yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      xyenon
      matthiasbeyer
      linsui
    ];
    mainProgram = "yazi";
  };
}
