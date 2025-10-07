{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  apple-sdk_15,
  common-updater-scripts,
  curl,
  installShellFiles,
  jq,
  versionCheckHook,
  writeShellScript,
  xxd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yabai";
  version = "7.1.15";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = "yabai";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HvaMPmXNlFVOezqWxqXaAUq8E8O2ZkXMQPwkKXCAOcY=";
  };

  nativeBuildInputs = [
    installShellFiles
    xxd
  ];

  buildInputs = [
    apple-sdk_15
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/icons/hicolor/scalable/apps}

    cp ./bin/yabai $out/bin/yabai
    cp ./assets/icon/icon.svg $out/share/icons/hicolor/scalable/apps/yabai.svg
    installManPage ./doc/yabai.1

    runHook postInstall
  '';

  postPatch =
    if stdenv.hostPlatform.isx86_64 then
      ''
        substituteInPlace makefile \
                --replace-fail "-arch arm64e" "" \
                --replace-fail "-arch arm64" ""
      ''
    # bash
    else if stdenv.hostPlatform.isAarch64 then
      ''
        substituteInPlace makefile \
                --replace-fail "-arch x86_64" ""
      ''
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {

    updateScript = writeShellScript "update-yabai" ''
      NEW_VERSION=$(${lib.getExe curl} --silent https://api.github.com/repos/koekeishiya/yabai/releases/latest | ${lib.getExe jq} '.tag_name | ltrimstr("v")' --raw-output)
      ${lib.getExe' common-updater-scripts "update-source-version"} "yabai" "$NEW_VERSION" --ignore-same-version
    '';
  };

  meta = {
    description = "Tiling window manager for macOS based on binary space partitioning";
    longDescription = ''
      yabai is a window management utility that is designed to work as an extension to the built-in
      window manager of macOS. yabai allows you to control your windows, spaces and displays freely
      using an intuitive command line interface and optionally set user-defined keyboard shortcuts
      using skhd and other third-party software.
    '';
    homepage = "https://github.com/koekeishiya/yabai";
    changelog = "https://github.com/koekeishiya/yabai/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "yabai";
    maintainers = with lib.maintainers; [
      cmacrae
      shardy
      khaneliman
    ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
