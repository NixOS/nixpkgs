{
  autoPatchelfHook,
  squashfsTools,
  alsa-lib,
  fetchurl,
  makeDesktopItem,
  makeWrapper,
  stdenv,
  lib,
  libsecret,
  libgbm,
  udev,
  wrapGAppsHook3,
  writeScript,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "termius";
  version = "9.32.2";
  revision = "240";

  src = fetchurl {
    # find the latest version with
    # curl -H 'X-Ubuntu-Series: 16' https://api.snapcraft.io/api/v1/snaps/details/termius-app | jq '.version'
    # and the url with
    # curl -H 'X-Ubuntu-Series: 16' https://api.snapcraft.io/api/v1/snaps/details/termius-app | jq '.download_url' -r
    # and the sha512 with
    # curl -H 'X-Ubuntu-Series: 16' https://api.snapcraft.io/api/v1/snaps/details/termius-app | jq '.download_sha512' -r
    url = "https://api.snapcraft.io/api/v1/snaps/download/WkTBXwoX81rBe3s3OTt3EiiLKBx2QhuS_${revision}.snap";
    hash = "sha512-TPfQ413zbnuKAhflLZPvLeVdrqdUEi+I/inWAs8SJ1j8rYW1TrHDyMB8S/HpWboRWXmUhPHulNXfGpHKUu453Q==";
  };

  desktopItem = makeDesktopItem {
    categories = [ "Network" ];
    comment = "The SSH client that works on Desktop and Mobile";
    desktopName = "Termius";
    exec = "termius-app";
    genericName = "Cross-platform SSH client";
    icon = "termius-app";
    name = "termius-app";
  };

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;
  dontWrapGApps = true;

  # TODO: migrate off autoPatchelfHook and use nixpkgs' electron
  nativeBuildInputs = [
    autoPatchelfHook
    squashfsTools
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    libsecret
    libgbm
    sqlite
  ];

  unpackPhase = ''
    runHook preUnpack
    unsquashfs "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    cd squashfs-root
    mkdir -p $out/opt/termius
    cp -r ./ $out/opt/termius

    mkdir -p "$out/share/applications" "$out/share/pixmaps"
    cp "${desktopItem}/share/applications/"* "$out/share/applications"
    cp meta/gui/icon.png $out/share/pixmaps/termius-app.png

    runHook postInstall
  '';

  runtimeDependencies = [ (lib.getLib udev) ];

  postFixup = ''
    makeWrapper $out/opt/termius/termius-app $out/bin/termius-app \
      "''${gappsWrapperArgs[@]}"
  '';

  passthru.updateScript = writeScript "update-termius" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p common-updater-scripts curl jq

    set -eu -o pipefail

    data=$(curl -H 'X-Ubuntu-Series: 16' \
    'https://api.snapcraft.io/api/v1/snaps/details/termius-app?fields=download_sha512,revision,version')

    version=$(jq -r .version <<<"$data")

    if [[ "x$UPDATE_NIX_OLD_VERSION" != "x$version" ]]; then

        revision=$(jq -r .revision <<<"$data")
        hash=$(nix --extra-experimental-features nix-command hash to-sri "sha512:$(jq -r .download_sha512 <<<"$data")")

        update-source-version "$UPDATE_NIX_ATTR_PATH" "$version" "$hash"
        update-source-version --ignore-same-hash --version-key=revision "$UPDATE_NIX_ATTR_PATH" "$revision" "$hash"

    fi
  '';

  meta = with lib; {
    description = "Cross-platform SSH client with cloud data sync and more";
    homepage = "https://termius.com/";
    downloadPage = "https://termius.com/linux/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [
      Br1ght0ne
      th0rgal
      Rishik-Y
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "termius-app";
  };
}
