{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  electron,
  makeWrapper,
  writableTmpDirAsHomeHook,
}:

buildNpmPackage rec {
  name = "vacuum-tube";
  version = "1.3.10";

  src = fetchFromGitHub {
    owner = "shy1132";
    repo = "VacuumTube";
    tag = "v${version}";
    hash = "sha256-xyfm8c/27WzO5FA9fCvSsDS0sRP/KPEPnN95QYDMVcM=";
  };

  npmDepsHash = "sha256-llNEUpakbQpa+4BXOXwKYfxUX9bIa3fVZBgDb59rlyY=";

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = true;
  };

  nativeBuildInputs = [
    makeWrapper
    writableTmpDirAsHomeHook
  ];

  buildPhase = ''
    runHook preBuild

    npx electron-builder -l --dir \
      -c.electronDist="${electron.dist}" \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r ./dist/*-unpacked $out/opt/VacuumTube

    # Install icons
    for i in 16 32 48 64 256 512; do
      install -Dm644 "assets/icons/$i"x"$i.png" \
        "$out/share/icons/hicolor/$i"x"$i/apps/rocks.shy.VacuumTube.png"
    done

    install -Dm644 flatpak/rocks.shy.VacuumTube.desktop $out/share/applications/VacuumTube.desktop

    substituteInPlace $out/share/applications/VacuumTube.desktop \
      --replace-fail 'Exec=startvacuumtube' 'Exec=VacuumTube'

    makeWrapper "${electron}/bin/electron" "$out/bin/VacuumTube" \
      --add-flags "$out/opt/VacuumTube/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    runHook postInstall
  '';

  meta = {
    description = "YouTube Leanback on the desktop, with enhancements";
    homepage = "https://github.com/shy1132/VacuumTube";
    mainProgram = "VacuumTube";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ theCapypara ];
  };
}
