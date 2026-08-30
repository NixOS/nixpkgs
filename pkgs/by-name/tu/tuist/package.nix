{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tuist";
  version = "4.202.1";

  src = fetchurl {
    url = "https://github.com/tuist/tuist/releases/download/${finalAttrs.version}/tuist.zip";
    hash = "sha256-J/xlwRRW3zLr03jA6Xpa5frlRQGHa/nmzzlj35/30tw=";
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

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [
    "HOME"
    "XDG_CACHE_HOME"
    "XDG_CONFIG_HOME"
    "XDG_STATE_HOME"
  ];
  preVersionCheck = ''
    export HOME=$(mktemp -d)
    export XDG_CACHE_HOME=$HOME/.cache
    export XDG_CONFIG_HOME=$HOME/.config
    export XDG_STATE_HOME=$HOME/.local/state
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=^([0-9.]+)$" ]; };

  meta = {
    description = "Command line tool that helps you generate, maintain and interact with Xcode projects";
    homepage = "https://tuist.dev";
    changelog = "https://github.com/tuist/tuist/blob/${finalAttrs.version}/cli/CHANGELOG.md";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ lib.maintainers.DimitarNestorov ];
    platforms = lib.platforms.darwin;
    mainProgram = "tuist";
  };
})
