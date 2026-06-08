{
  lib,
  apple-sdk_15,
  bintools-unwrapped,
  cups,
  fetchFromGitHub,
  installShellFiles,
  llvmPackages,
  nix-update-script,
  stdenv,
  versionCheckHook,
  xxd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "yabai";
  version = "7.1.25";

  src = fetchFromGitHub {
    owner = "asmvik";
    repo = "yabai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-61knfbahxxlJnVZy47347slsjUGiQUJyZh58G97SDkE=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    xxd
  ];

  buildInputs = [
    apple-sdk_15
  ];

  # Upstream Makefile races clean-build against linking under parallel make.
  enableParallelBuilding = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/icons/hicolor/scalable/apps}

    cp ./bin/yabai $out/bin/yabai
    cp ./assets/icon/icon.svg $out/share/icons/hicolor/scalable/apps/yabai.svg
    installManPage ./doc/yabai.1

    runHook postInstall
  '';

  # yabai's makefile builds universal (x86_64 + arm64/arm64e) binaries with
  # `xcrun clang`. Collapse it to the host arch and use plain `clang`, since the
  # scripting addition (arm64e) is compiled in preBuild with the unwrapped clang,
  # which needs the SDK/clang/CUPS include paths passed explicitly.
  postPatch =
    let
      arch = stdenv.hostPlatform.darwinArch;
      # The scripting addition is injected into arm64e system processes, so on
      # aarch64 it must be arm64e even though the main binary stays arm64.
      archSA = "${arch}${lib.optionalString stdenv.hostPlatform.isAarch64 "e"}";
      clangFlags = lib.concatStringsSep " " [
        "-isystem $(SDKROOT)/usr/include"
        "-isystem ${llvmPackages.libclang.lib}/lib/clang/*/include"
        "-isystem ${lib.getDev cups}/include"
        "-F$(SDKROOT)/System/Library/Frameworks"
        "-L$(SDKROOT)/usr/lib"
        "-Wl,-no_uuid"
      ];
    in
    ''
      substituteInPlace makefile \
        --replace-fail "-arch x86_64 -arch arm64e" "-arch ${archSA}" \
        --replace-fail "-arch x86_64 -arch arm64" "-arch ${arch}" \
        --replace-fail 'xcrun clang' 'clang ${clangFlags}'
    '';

  # The cc-wrapper can't target arm64e, so build the scripting addition (the only
  # arm64e part) with the unwrapped clang.
  preBuild = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    make ./src/osax/payload_bin.c ./src/osax/loader_bin.c "PATH=${bintools-unwrapped}/bin:${llvmPackages.clang-unwrapped}/bin:$PATH"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiling window manager for macOS based on binary space partitioning";
    longDescription = ''
      yabai is a window management utility that is designed to work as an extension to the built-in
      window manager of macOS. yabai allows you to control your windows, spaces and displays freely
      using an intuitive command line interface and optionally set user-defined keyboard shortcuts
      using skhd and other third-party software.
    '';
    homepage = "https://github.com/asmvik/yabai";
    changelog = "https://github.com/asmvik/yabai/blob/v${finalAttrs.version}/CHANGELOG.md";
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
