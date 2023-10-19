{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "thud";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "donovanglover";
    repo = "thud";
    rev = version;
    hash = "sha256-3MxmVKs0huXPnL9mqDniaIarkAvJmwSOMii2ntXtOos=";
  };

  cargoHash = "sha256-Hk3HlcA253FAA9hw5p9W+Mvec84zLo7bEmM2/BbmjiM=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    install -Dm644 assets/thud.thumbnailer $out/share/thumbnailers/thud.thumbnailer
    substituteInPlace $out/share/thumbnailers/thud.thumbnailer --replace "thud" "$out/bin/thud"

    installManPage man/thud.1

    installShellCompletion --cmd thud \
      --bash <(cat completions/thud.bash) \
      --fish <(cat completions/thud.fish) \
      --zsh <(cat completions/_thud)
  '';

  meta = with lib; {
    description = "Generate directory thumbnails for GTK-based file browsers from images inside them";
    homepage = "https://github.com/donovanglover/thud";
    license = licenses.mit;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "thud";
  };
}
