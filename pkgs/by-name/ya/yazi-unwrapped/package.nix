{ rustPlatform
, fetchFromGitHub
, lib

, installShellFiles
, stdenv
, Foundation

, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "yazi";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "sxyazi";
    repo = "yazi";
    rev = "v${version}";
    hash = "sha256-c8fWWCOVBqQVdQch9BniCaJPrVEOCv35lLH8/hMIbvE=";
  };

  cargoHash = "sha256-VeDyO+KCD3Axse4iPIoRxIvoAn3L33e2ObBZFV/REeg=";

  env.YAZI_GEN_COMPLETIONS = true;

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optionals stdenv.isDarwin [ Foundation ];

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
    maintainers = with lib.maintainers; [ xyenon matthiasbeyer ];
    mainProgram = "yazi";
  };
}
