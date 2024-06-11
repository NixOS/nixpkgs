{
  lib,
  stdenv,
  overrideSDK,
  fetchFromGitHub,
  fetchzip,
  installShellFiles,
  testers,
  writeShellScript,
  common-updater-scripts,
  curl,
  darwin,
  jq,
  xcodebuild,
  xxd,
  yabai,
}:
let
  inherit (darwin.apple_sdk_11_0.frameworks)
    Carbon
    Cocoa
    ScriptingBridge
    SkyLight
    ;

  stdenv' = if stdenv.isDarwin then overrideSDK stdenv "11.0" else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "yabai";
  version = "7.1.1";

  src =
    finalAttrs.passthru.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  env = {
    # silence service.h error
    NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";
  };

  nativeBuildInputs =
    [ installShellFiles ]
    ++ lib.optionals stdenv.isx86_64 [
      xcodebuild
      xxd
    ];

  buildInputs = lib.optionals stdenv.isx86_64 [
    Carbon
    Cocoa
    ScriptingBridge
    SkyLight
  ];

  dontConfigure = true;
  dontBuild = stdenv.isAarch64;
  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/icons/hicolor/scalable/apps}

    cp ./bin/yabai $out/bin/yabai
    ${lib.optionalString stdenv.isx86_64 "cp ./assets/icon/icon.svg $out/share/icons/hicolor/scalable/apps/yabai.svg"}
    installManPage ./doc/yabai.1

    runHook postInstall
  '';

  postPatch =
    lib.optionalString stdenv.isx86_64 # bash
      ''
        # aarch64 code is compiled on all targets, which causes our Apple SDK headers to error out.
        # Since multilib doesn't work on darwin i dont know of a better way of handling this.
        substituteInPlace makefile \
        --replace "-arch arm64e" "" \
        --replace "-arch arm64" "" \
        --replace "clang" "${stdenv.cc.targetPrefix}clang"

        # `NSScreen::safeAreaInsets` is only available on macOS 12.0 and above, which frameworks aren't packaged.
        # When a lower OS version is detected upstream just returns 0, so we can hardcode that at compile time.
        # https://github.com/koekeishiya/yabai/blob/v4.0.2/src/workspace.m#L109
        substituteInPlace src/workspace.m \
        --replace 'return screen.safeAreaInsets.top;' 'return 0;'
      '';

  passthru = {
    tests.version = testers.testVersion {
      package = yabai;
      version = "yabai-v${finalAttrs.version}";
    };

    sources = {
      # Unfortunately compiling yabai from source on aarch64-darwin is a bit complicated. We use the precompiled binary instead for now.
      # See the comments on https://github.com/NixOS/nixpkgs/pull/188322 for more information.
      "aarch64-darwin" = fetchzip {
        url = "https://github.com/koekeishiya/yabai/releases/download/v${finalAttrs.version}/yabai-v${finalAttrs.version}.tar.gz";
        hash = "sha256-LNOAT1vm6EEmcKdshMKjYWFfoRoRNbgZgjEpOTacWc8=";
      };
      "x86_64-darwin" = fetchFromGitHub {
        owner = "koekeishiya";
        repo = "yabai";
        rev = "v${finalAttrs.version}";
        hash = "sha256-dznMjSaS2kkyYf7JrNf1Y++Nb5YFOmk/JQP3BBrf5Bk=";
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
        update-source-version "yabai" "0" "${lib.fakeHash}" --source-key="sources.$platform"
        update-source-version "yabai" "$NEW_VERSION" --source-key="sources.$platform"
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
      ivar
      khaneliman
    ];
    sourceProvenance =
      with lib.sourceTypes;
      lib.optionals stdenv.isx86_64 [ fromSource ] ++ lib.optionals stdenv.isAarch64 [ binaryNativeCode ];
  };
})
