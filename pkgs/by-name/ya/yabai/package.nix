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
  version = "7.1.16";

  src =
    finalAttrs.passthru.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    xxd
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isx86_64 [
    apple-sdk_15
  ];

  dontConfigure = true;
  dontBuild = stdenv.hostPlatform.isAarch64;
  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/icons/hicolor/scalable/apps}

    cp ./bin/yabai $out/bin/yabai
    ${lib.optionalString stdenv.hostPlatform.isx86_64 "cp ./assets/icon/icon.svg $out/share/icons/hicolor/scalable/apps/yabai.svg"}
    installManPage ./doc/yabai.1

    runHook postInstall
  '';

  postPatch =
    lib.optionalString stdenv.hostPlatform.isx86_64 # bash
      ''
        # aarch64 code is compiled on all targets, which causes our Apple SDK headers to error out.
        # Since multilib doesn't work on darwin i dont know of a better way of handling this.
        substituteInPlace makefile \
        --replace-fail "-arch arm64e" "" \
        --replace-fail "-arch arm64" ""
      '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    sources = {
      # Unfortunately compiling yabai from source on aarch64-darwin is a bit complicated. We use the precompiled binary instead for now.
      # See the comments on https://github.com/NixOS/nixpkgs/pull/188322 for more information.
      "aarch64-darwin" = fetchzip {
        url = "https://github.com/koekeishiya/yabai/releases/download/v${finalAttrs.version}/yabai-v${finalAttrs.version}.tar.gz";
        hash = "sha256-rEO+qcat6heF3qrypJ02Ivd2n0cEmiC/cNUN53oia4w=";
      };
      "x86_64-darwin" = fetchFromGitHub {
        owner = "koekeishiya";
        repo = "yabai";
        rev = "v${finalAttrs.version}";
        hash = "sha256-WXvM0ub4kJ3rKXynTxmr2Mx+LzJOgmm02CcEx2nsy/A=";
      };
    };

    updateScript = writeShellScript "update-yabai" ''
      NEW_VERSION=$(${lib.getExe curl} --silent https://api.github.com/repos/koekeishiya/yabai/releases/latest | ${lib.getExe jq} '.tag_name | ltrimstr("v")' --raw-output)
      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        ${lib.getExe' common-updater-scripts "update-source-version"} "yabai" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
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
    platforms = builtins.attrNames finalAttrs.passthru.sources;
    mainProgram = "yabai";
    maintainers = with lib.maintainers; [
      cmacrae
      shardy
      khaneliman
    ];
    sourceProvenance =
      with lib.sourceTypes;
      lib.optionals stdenv.hostPlatform.isx86_64 [ fromSource ]
      ++ lib.optionals stdenv.hostPlatform.isAarch64 [ binaryNativeCode ];
  };
})
