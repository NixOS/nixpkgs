{
  fetchurl,
  lib,
  stdenv,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zitadel-bin";
  version = "2.49.0";
  system =
    if stdenv.isLinux && stdenv.isx86_64 then
      "linux-amd64"
    else if stdenv.isLinux && stdenv.isAarch64 then
      "linux-arm64"
    else
      "";

  src = fetchurl {
    url = "https://github.com/zitadel/zitadel/releases/download/v${finalAttrs.version}/zitadel-${finalAttrs.system}.tar.gz";

    hash =
      if stdenv.isLinux && stdenv.isAarch64 then
        "sha256-JPOLtXnmA+LW2X8ZCRSjZLdsYJCUof8dcV0pZX0lXNY="
      else if stdenv.isLinux && stdenv.isx86_64 then
        "sha256-PuDSXmvqHEUzqKbJ11PZ7W9Q8snhmawPUT8QfDm0TcA="
      else
        builtins.throw "Unsupported platform, please contact Nixpkgs maintainers for zitadel package";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    tar -xf $src
    runHook preInstall
    install -D zitadel-${finalAttrs.system}/zitadel $out/bin/zitadel
    runHook postInstall
  '';

  meta = with lib; {
    description = "Identity and access management platform";
    homepage = "https://zitadel.com/";
    downloadPage = "https://github.com/zitadel/zitadel/releases";
    platforms = platforms.linux;
    license = licenses.asl20;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    maintainers = with maintainers; [ bhankas ];
    mainProgram = "zitadel";
  };
})
