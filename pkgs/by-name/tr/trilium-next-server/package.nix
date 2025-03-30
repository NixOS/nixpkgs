{
  stdenv,
  lib,
  autoPatchelfHook,
  fetchurl,
  makeBinaryWrapper,
}:

let
  version = "0.92.4";

  serverSource_x64.url = "https://github.com/TriliumNext/Notes/releases/download/v${version}/TriliumNextNotes-Server-v${version}-linux-x64.tar.xz";
  serverSource_x64.sha256 = "1bcacr5sxmrq9zvh8xjyr30y5mz0y6qyx2m18dblswdi0mbi7cv4";
  serverSource_arm64.url = "https://github.com/TriliumNext/Notes/releases/download/v${version}/TriliumNextNotes-Server-v${version}-linux-arm64.tar.xz";
  serverSource_arm64.sha256 = "04mjkqywwdax46r8q8wygi9dxglz2qipmlrv3cqqpdvjm0yxh2g2";

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

  patches = [
    # patch logger to use console instead of rolling files
    ./0001-Use-console-logger-instead-of-rolling-files.patch
  ];

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
      --add-flags "src/main"

    # Clean up broken symlinks and build tools.
    rm "$out"/share/trilium-server/node/bin/{npm,npx}
    rm -r "$out"/share/trilium-server/node_modules/{@npmcli,@rollup,@babel,.bin}

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
