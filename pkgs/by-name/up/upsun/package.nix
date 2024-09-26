{
  stdenvNoCC,
  lib,
  fetchurl,
  testers,
  installShellFiles,
  upsun
}:

let versions = lib.importJSON ./versions.json;
    arch = if stdenvNoCC.hostPlatform.isx86_64 then "amd64"
           else if stdenvNoCC.hostPlatform.isAarch64 then "arm64"
           else throw "Unsupported architecture";
    os = if stdenvNoCC.hostPlatform.isLinux then "linux"
         else if stdenvNoCC.hostPlatform.isDarwin then "darwin"
         else throw "Unsupported os";
    versionInfo = versions."${os}-${arch}";
    inherit (versionInfo) hash url;

in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "upsun";
  inherit (versions) version;

  nativeBuildInputs = [ installShellFiles ];

  # run ./update
  src = fetchurl { inherit hash url; };

  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";
  installPhase = ''
    runHook preInstall

    install -Dm755 upsun $out/bin/upsun

    installShellCompletion completion/bash/upsun.bash \
        completion/zsh/_upsun

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
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
