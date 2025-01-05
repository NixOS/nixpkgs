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
  version = "7.1.5";

  src =
    finalAttrs.passthru.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs =
    [ installShellFiles ]
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
        hash = "sha256-o+9Z3Kxo1ff1TZPmmE6ptdOSsruQzxZm59bdYvhRo3c=";
      };
      "x86_64-darwin" = fetchFromGitHub {
        owner = "koekeishiya";
        repo = "yabai";
        rev = "v${finalAttrs.version}";
        hash = "sha256-6HBWJvjVWagtHrfjWaYSRcnQOuwTBVeVxo3wc+jSlyE=";
      };
    };

    updateScript = writeShellScript "update-yabai" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl --silent https://api.github.com/repos/koekeishiya/yabai/releases/latest | jq '.tag_name | ltrimstr("v")' --raw-output)
      if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi
      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        update-source-version "yabai" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
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
