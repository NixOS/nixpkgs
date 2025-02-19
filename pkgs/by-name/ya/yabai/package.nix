{
  lib,
  apple-sdk_15,
  bintools-unwrapped,
  cups,
  fetchFromGitHub,
  installShellFiles,
  llvmPackages_19,
  replaceVars,
  stdenv,
  versionCheckHook,
  xxd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "yabai";
  version = "7.1.10";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = "yabai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4OYB+RlAUD8LcRcUNIEXWfFFedTmQFzcTgqd1g/tdWc=";
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

  patches =
    let
      ARCH = stdenv.hostPlatform.darwinArch;
    in
    [
      (replaceVars ./0001-single-arch-build.patch {
        inherit ARCH;
        ARCH_SA = "${ARCH}${lib.optionalString stdenv.hostPlatform.isAarch64 "e"}";
        CLANG_LIB = llvmPackages_19.libclang.lib;
        CUPS_DEV = lib.getDev cups;
      })
    ];

  # On aarch64-darwin, only the scripting addition is arm64e, prebuild that using the unwrapped clang
  preBuild = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    make ./src/osax/payload_bin.c ./src/osax/loader_bin.c "PATH=${bintools-unwrapped}/bin:${llvmPackages_19.clang-unwrapped}/bin:$PATH"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

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
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
