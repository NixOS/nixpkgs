{
  stdenv,
  lib,
  autoPatchelfHook,
  fetchurl,
  makeBinaryWrapper,
}:

let
  version = "0.95.0";

  serverSource_x64.url = "https://github.com/TriliumNext/Notes/releases/download/v${version}/TriliumNextNotes-Server-v${version}-linux-x64.tar.xz";
  serverSource_x64.sha256 = "1rjl38i6l894kwpmc925amf9zbwyjlc4sqh3skm1f13vhv9pj9dx";
  serverSource_arm64.url = "https://github.com/TriliumNext/Notes/releases/download/v${version}/TriliumNextNotes-Server-v${version}-linux-arm64.tar.xz";
  serverSource_arm64.sha256 = "1rpzc13vdp5b3iwwc1l6h78nb5iairlxbflwvjwhy1149lpqnn8m";

  serverSource =
    if stdenv.hostPlatform.isx86_64 then
      serverSource_x64
    else if stdenv.hostPlatform.isAarch64 then
      serverSource_arm64
    else
      throw "${stdenv.hostPlatform.config} not supported by trilium-next-server";
in
stdenv.mkDerivation {
  pname = "trilium-next-server";
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
    homepage = "https://github.com/TriliumNext/Notes";
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
