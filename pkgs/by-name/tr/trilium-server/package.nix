{
  stdenv,
  lib,
  autoPatchelfHook,
  fetchurl,
  makeBinaryWrapper,
}:

let
  version = "0.104.0";

  serverSource_x64.url = "https://github.com/TriliumNext/Trilium/releases/download/v${version}/TriliumNotes-Server-v${version}-linux-x64.tar.xz";
  serverSource_x64.hash = "sha256-lrZL0c9ijvjYUQlN6BN1BhHR2KacFG6h6KzIlkIKLGk=";
  serverSource_arm64.url = "https://github.com/TriliumNext/Trilium/releases/download/v${version}/TriliumNotes-Server-v${version}-linux-arm64.tar.xz";
  serverSource_arm64.hash = "sha256-EgqYA7IBSt9tZ12MgktIKhJ9/ww/prTCE5Z7enMUk7Q=";

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

    makeWrapper "$out/share/trilium-server/node/bin/node" "$out/bin/trilium-server" \
      --chdir "$out/share/trilium-server" \
      --add-flags "main.cjs"

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
