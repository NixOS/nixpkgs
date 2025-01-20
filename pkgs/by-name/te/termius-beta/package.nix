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
  mesa,
  udev,
  wrapGAppsHook3,
  writeScript,
}:

stdenv.mkDerivation rec {
  pname = "termius-beta";
  version = "9.9.0";
  revision = "341";

  src = fetchurl {
    # find the latest version with
    # curl -H 'X-Ubuntu-Series: 16' https://api.snapcraft.io/api/v1/snaps/details/termius-beta | jq '.version'
    # and the url with
    # curl -H 'X-Ubuntu-Series: 16' https://api.snapcraft.io/api/v1/snaps/details/termius-beta | jq '.download_url' -r
    # and the sha512 with
    # curl -H 'X-Ubuntu-Series: 16' https://api.snapcraft.io/api/v1/snaps/details/termius-beta | jq '.download_sha512' -r
    url = "https://api.snapcraft.io/api/v1/snaps/download/yyZzRdoyiRz3EM7iuvjhaIjDfnlFJcZs_${revision}.snap";
    hash = "sha512-PnFLD6LJqYcg1ESjWQZ8zZUTDyquXdyQXuB9JYE9Ptjl9VJYx/GoUi9wRCBaBaNn81G1mr+nAxVYXXJg5YxLJw==";
  };

  desktopItem = makeDesktopItem {
    categories = [ "Network" ];
    comment = "The SSH client that works on Desktop and Mobile";
    desktopName = "Termius";
    exec = "termius-beta";
    genericName = "Cross-platform SSH client";
    icon = "termius-beta";
    name = "termius-beta";
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
    mesa
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
    cp meta/gui/icon.png $out/share/pixmaps/termius-beta.png
    runHook postInstall
  '';

  runtimeDependencies = [ (lib.getLib udev) ];

  postFixup = ''
    makeWrapper $out/opt/termius/termius-beta $out/bin/termius-beta \
      "''${gappsWrapperArgs[@]}"
  '';

  passthru.updateScript = writeScript "update-termius" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p common-updater-scripts curl jq
    set -eu -o pipefail
    data=$(curl -H 'X-Ubuntu-Series: 16' \
    'https://api.snapcraft.io/api/v1/snaps/details/termius-beta?fields=download_sha512,revision,version')
    version=$(jq -r .version <<<"$data")
    if [[ "x$UPDATE_NIX_OLD_VERSION" != "x$version" ]]; then
        revision=$(jq -r .revision <<<"$data")
        hash=$(nix hash to-sri "sha512:$(jq -r .download_sha512 <<<"$data")")
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
    maintainers = with maintainers; [ Rishik-Y ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "termius-beta";
  };
}
