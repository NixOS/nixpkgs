{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sysc-greet";
  version = "1.3.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Nomadcxx";
    repo = "sysc-greet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7DORRNZdyE/iZcbERxK++XBuh74rUi49ityX9EhQ98s=";
  };

  vendorHash = "sha256-6JhzDC7uu9RC4K9WJTzOR2DMo+nsUStrVQWl9KdecQw=";

  subPackages = [ "cmd/sysc-greet" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.dataDir=${placeholder "out"}/share/sysc-greet"
  ];

  postInstall = ''
    datadir=$out/share/sysc-greet
    mkdir -p $datadir/borders $datadir/config
    cp -r ascii_configs fonts themes wallpapers THIRD_PARTY_NOTICES.md $datadir/
    cp cmd/sysc-greet/assets/borders/*.ans $datadir/borders/

    # Compositor and kitty configs for the NixOS module to install under /etc/greetd
    cp config/* $datadir/config/
    substituteInPlace $datadir/config/* \
      --replace-quiet /usr/local/bin/sysc-greet $out/bin/sysc-greet
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Graphical console greeter for greetd with ASCII art, themes and animated backgrounds";
    homepage = "https://github.com/Nomadcxx/sysc-greet";
    changelog = "https://github.com/Nomadcxx/sysc-greet/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nomadcxx ];
    mainProgram = "sysc-greet";
    platforms = lib.platforms.linux;
  };
})
