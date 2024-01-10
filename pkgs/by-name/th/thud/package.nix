{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "thud";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "donovanglover";
    repo = "thud";
    rev = version;
    hash = "sha256-BmrJaZ1IKXjx4/QkBDZyXvTTaalfEOKsBp9ZCW8px7I=";
  };

  cargoHash = "sha256-rmVVdes7GuGV+ClqJGxNIrs7oSwe8/ZHFD6OfP/UW7A=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    install -Dm644 assets/thud.thumbnailer $out/share/thumbnailers/thud.thumbnailer
    substituteInPlace $out/share/thumbnailers/thud.thumbnailer --replace "thud" "$out/bin/thud"

    installManPage target/man/thud.1

    installShellCompletion --cmd thud \
      --bash <(cat target/completions/thud.bash) \
      --fish <(cat target/completions/thud.fish) \
      --zsh <(cat target/completions/_thud)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Generate directory thumbnails for GTK-based file browsers from images inside them";
    homepage = "https://github.com/donovanglover/thud";
    license = licenses.mit;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "thud";
  };
}
