{
  stdenvNoCC,
  lib,
  fetchurl,
  testers,
  upsun
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "upsun";
  version = "5.0.13";

  src =
    {
      x86_64-darwin = fetchurl {
        url = "https://github.com/platformsh/cli/releases/download/${finalAttrs.version}/upsun_${finalAttrs.version}_darwin_all.tar.gz";
        hash = "sha256-5JKXtAUnqrlufyNE05uZjEDfJv557auYPriTxvUbMJI=";
      };
      aarch64-darwin = fetchurl {
        url = "https://github.com/platformsh/cli/releases/download/${finalAttrs.version}/upsun_${finalAttrs.version}_darwin_all.tar.gz";
        hash = "sha256-5JKXtAUnqrlufyNE05uZjEDfJv557auYPriTxvUbMJI=";
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/platformsh/cli/releases/download/${finalAttrs.version}/upsun_${finalAttrs.version}_linux_amd64.tar.gz";
        hash = "sha256-fjVL/sbO1wmaJ4qZpUMV/4Q4Jzf0p6qx0ElRdY5EUJU=";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/platformsh/cli/releases/download/${finalAttrs.version}/upsun_${finalAttrs.version}_linux_arm64.tar.gz";
        hash = "sha256-MNlQkwsg5SuIQJBDy7yVtcda1odpaUZezCgrat6OW2Q=";
      };
    }
    .${stdenvNoCC.system}
      or (throw "${finalAttrs.pname}-${finalAttrs.version}: ${stdenvNoCC.system} is unsupported.");

  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";
  installPhase = ''
    runHook preInstall

    install -Dm755 upsun $out/bin/upsun

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      inherit (finalAttrs) version;
      package = upsun;
    };
  };

  meta = {
    description = "Unified tool for managing your Upsun services from the command line";
    homepage = "https://github.com/platformsh/cli";
    license = lib.licenses.mit;
    mainProgram = "upsun";
    maintainers = with lib.maintainers; [ spk ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
