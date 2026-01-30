{
  stdenv,
  lib,
  fetchzip,
}:

let
  os = if stdenv.hostPlatform.isDarwin then "macos" else "linux";
  arch = if stdenv.hostPlatform.isAarch64 then "aarch64" else "x86_64";
  platform = "${os}-${arch}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "urbit";
  version = "3.5";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${finalAttrs.version}/${platform}.tgz";
    sha256 =
      {
        x86_64-linux = "sha256-eB80GuyNuVZbBsyNnek8UCtquZbNt5G4Co7IKqq7aeI=";
        aarch64-linux = "sha256-imbzAsjjznLuxee9mWXpsG/dKEJxdEOTw+JFc4DbQ2Q=";
        x86_64-darwin = "sha256-0c1ewdrVsfSUivrcLwVuxZdcyrOAKXF7P9W+B7o5aNU=";
        aarch64-darwin = "sha256-j8PJ04zRz2sZdpetLyzwRasj0CkiRGY+GvzWXG90IaE=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  postInstall = ''
    install -m755 -D vere-v${finalAttrs.version}-${platform} $out/bin/urbit
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
