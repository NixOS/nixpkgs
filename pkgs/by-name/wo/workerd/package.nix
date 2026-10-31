{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
}:

let
  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  npmPlatform = selectSystem {
    x86_64-linux = "linux-64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  };
  compatibilityDateOf =
    version:
    let
      date = lib.elemAt (lib.splitVersion version) 1;
    in
    "${lib.substring 0 4 date}-${lib.substring 4 2 date}-${lib.substring 6 2 date}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "workerd";
  version = "1.20261022.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/@cloudflare/workerd-${npmPlatform}/-/workerd-${npmPlatform}-${finalAttrs.version}.tgz";
    hash = selectSystem {
      x86_64-linux = "sha256-jUpBbY7TqlBqzN8KgjkL2j+lTF2s7wXdSGF72jsNb/k=";
      aarch64-linux = "sha256-33xS2VSvHCwzZNF2tTSyfnS+YVb9PUcDTYmAfCc09ws=";
      aarch64-darwin = "sha256-rSx0pN8jB4jIM66InWKRH0y4LMhsmHuUpStR7Ch2bX0=";
    };
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/workerd $out/bin/workerd
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  preVersionCheck = ''
    version=${compatibilityDateOf finalAttrs.version}
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "JavaScript and WebAssembly runtime that powers Cloudflare Workers";
    homepage = "https://github.com/cloudflare/workerd";
    changelog = "https://github.com/cloudflare/workerd/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://www.npmjs.com/package/workerd";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ _81reap ];
    mainProgram = "workerd";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
