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
  version = "4.2";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${finalAttrs.version}/${platform}.tgz";
    sha256 =
      {
        x86_64-linux = "sha256-UfQJgN1aMMzO1BRm8PZSrIX8EwdQAb4YVB/8tXouM1k=";
        aarch64-linux = "sha256-4jXOnTJ8mjotRFMNpwDEAM4ZcQ71IKcRBEj9tjm4iJU=";
        x86_64-darwin = "sha256-/dkUVj8rkpQUpAuvs5ZsqVHVlhLAPp7yd6MUN+mqn8Y=";
        aarch64-darwin = "sha256-PTlYe5ryx5A0cSHSzbIT/Ux44eZYvt5y/edQP329/54=";
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
