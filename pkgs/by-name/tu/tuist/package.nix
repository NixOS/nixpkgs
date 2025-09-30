{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tuist";
  version = "4.53.4";

  src = fetchurl {
    url = "https://github.com/tuist/tuist/releases/download/${finalAttrs.version}/tuist.zip";
    hash = "sha256-4YQY94/uWh/H4cCzhdQ3KxIh19D8mmUCCDKMF8ZwA4E=";
  };

  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/tuist/
    unzip $src -d $out/opt/tuist/

    mkdir -p $out/bin/
    ln -s $out/opt/tuist/tuist $out/bin/tuist

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Command line tool that helps you generate, maintain and interact with Xcode projects";
    homepage = "https://tuist.dev";
    changelog = "https://github.com/tuist/tuist/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ lib.maintainers.DimitarNestorov ];
    platforms = lib.platforms.darwin;
    mainProgram = "tuist";
  };
})
