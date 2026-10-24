{
  lib,
  stdenvNoCC,
  fetchurl,
  writeShellApplication,
  cacert,
  common-updater-scripts,
  curl,
  unzip,
}:

stdenvNoCC.mkDerivation {
  pname = "trailer";
  version = "1.9.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    name = "Trailer.zip";
    url = "https://github.com/ptsochantaris/trailer/releases/download/v1.9.0/Trailer-1951.zip";
    hash = "sha256-5pCLdKEihEehgopqVCIIHGfWfJ4JcIRIRx/UocTA6cc=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = "Trailer.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Trailer.app"
    cp -R . "$out/Applications/Trailer.app"
    mkdir -p "$out/bin"
    ln -s "$out/Applications/Trailer.app/Contents/MacOS/Trailer" "$out/bin/trailer"

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "trailer-update-script";
    runtimeInputs = [
      cacert
      common-updater-scripts
      curl
    ];
    text = ''
      url=$(curl --fail --silent --show-error ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
        "https://api.github.com/repos/ptsochantaris/trailer/releases/latest" \
        | grep -o 'https://github\.com/ptsochantaris/trailer/releases/download/[^"]*\.zip' \
        | head -n 1)
      tag="''${url%/*}"
      tag="''${tag##*/}"
      version="''${tag#v}"

      update-source-version trailer "$version" "" "$url"
    '';
  });

  meta = {
    description = "Manage GitHub pull requests and issues from the macOS menu bar";
    homepage = "https://ptsochantaris.github.io/trailer/";
    license = lib.licenses.mit;
    mainProgram = "trailer";
    maintainers = with lib.maintainers; [ ciferkey ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
