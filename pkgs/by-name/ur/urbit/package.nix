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
  version = "4.6";

  src = fetchurl {
    url = "https://github.com/urbit/vere/releases/download/vere-v${finalAttrs.version}/${platform}.tgz";
    sha256 =
      {
        x86_64-linux = "1bm32airwqi6pkxlkd0hwrwd0gwm9x5y05dzgy27yxnbcrnyjcpk";
        aarch64-linux = "126hw995xipbx9kb4ml8kn6xwkwd96q90cbr3q143ya2wl1sabya";
        aarch64-darwin = "0dsapvlyfr2cb9c16b46bcnvq75by87ybys96zhf16k92z4rzrfv";
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
      "aarch64-darwin"
    ];
    maintainers = [ lib.maintainers.matthew-levan ];
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "urbit";
  };
})
