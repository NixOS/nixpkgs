{
  stdenv,
  lib,
  autoPatchelfHook,
  fetchurl,
  makeBinaryWrapper,
  nodejs_24,
}:

let
  version = "0.106.1";

  serverSource_x64.url = "https://github.com/TriliumNext/Trilium/releases/download/v${version}/TriliumNotes-Server-v${version}-linux-x64.tar.xz";
  serverSource_x64.hash = "sha256-WbWR275Cizo4pJPYlUuwOE8RjFyT5F2b/YuJJwwo1iA=";
  serverSource_arm64.url = "https://github.com/TriliumNext/Trilium/releases/download/v${version}/TriliumNotes-Server-v${version}-linux-arm64.tar.xz";
  serverSource_arm64.hash = "sha256-COw0h0egWCX7Bhtz9LewYC2Y9xx8Tf7KZqBa93DbvsE=";

  serverSource =
    if stdenv.hostPlatform.isx86_64 then
      serverSource_x64
    else if stdenv.hostPlatform.isAarch64 then
      serverSource_arm64
    else
      throw "${stdenv.hostPlatform.config} not supported by trilium-server";
in
stdenv.mkDerivation {
  pname = "trilium-server";
  inherit version;

  src = fetchurl serverSource;

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/trilium-server"

    cp -r ./* "$out/share/trilium-server/"
    rm -r $out/share/trilium-server/node/bin

    # Unused musl prebuilds confuse autoPatchelfHook (glibc-only).
    rm -f "$out/share/trilium-server/node_modules/better-sqlite3/prebuilds"/linuxmusl-*.node

    makeWrapper ${lib.getExe nodejs_24} "$out/bin/trilium-server" \
      --chdir "$out/share/trilium-server" \
      --add-flags "main.mjs"

    runHook postInstall
  '';

  meta = {
    description = "Hierarchical note taking application with focus on building large personal knowledge bases";
    homepage = "https://github.com/TriliumNext/Trilium";
    license = lib.licenses.agpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [
      eliandoran
      fliegendewurst
    ];
    mainProgram = "trilium-server";
  };
}
