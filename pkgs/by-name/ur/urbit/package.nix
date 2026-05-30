{
  stdenv,
  lib,
  fetchurl,
}:

let
  os = if stdenv.hostPlatform.isDarwin then "macos" else "linux";
  arch = if stdenv.hostPlatform.isAarch64 then "aarch64" else "x86_64";
  platform = "${os}-${arch}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "urbit";
  version = "4.3";

  src = fetchurl {
    url = "https://github.com/urbit/vere/releases/download/vere-v${finalAttrs.version}/${platform}.tgz";
    sha256 =
      {
        x86_64-linux = "14svyh258iqw8zrbf6nmsc1rfhrsyp6wb2a84fc72lsh28jm7fm0";
        aarch64-linux = "0gbpfsysmag9wnka9lgd812wsgrp78fr5l5nwin524zx47cq0fdm";
        x86_64-darwin = "0ff77jpsblgbsx03w0yqqsnyrw6g6c90bcj4bvm6idjdxknfnpfv";
        aarch64-darwin = "037860zqp9l9gzr3s0d8pbis3xsd26f3a6k63rpvjn76bpwy6swb";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  unpackPhase = ''
    mkdir src
    tar -C src -xf $src
  '';

  postInstall = ''
    install -m755 -D src/vere-v${finalAttrs.version}-${platform} $out/bin/urbit
  '';

  passthru.updateScript = ./update-bin.sh;

  meta = {
    homepage = "https://urbit.org";
    description = "Operating function";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = [ lib.maintainers.matthew-levan ];
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "urbit";
  };
})
