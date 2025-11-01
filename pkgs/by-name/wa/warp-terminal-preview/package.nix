{
  lib,
  stdenvNoCC,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  undmg,
  zstd,
  alsa-lib,
  curl,
  fontconfig,
  libglvnd,
  libxkbcommon,
  vulkan-loader,
  wayland,
  xdg-utils,
  xorg,
  zlib,
  makeWrapper,
}:

let
  pname = "warp-terminal-preview";
  versions = lib.importJSON ./versions.json;
  passthru.updateScript = ./update.sh;

  linux_arch = if stdenv.hostPlatform.system == "x86_64-linux" then "x86_64" else "aarch64";

  linux = stdenv.mkDerivation (finalAttrs: {
    inherit pname meta passthru;
    inherit (versions."linux_${linux_arch}") version;
    src = fetchurl {
      inherit (versions."linux_${linux_arch}") hash;
      url = "https://releases.warp.dev/preview/v${finalAttrs.version}/warp-terminal-preview-v${finalAttrs.version}-1-${linux_arch}.pkg.tar.zst";
    };

    sourceRoot = ".";

    postPatch = ''
      substituteInPlace usr/bin/warp-terminal-preview \
        --replace-fail /opt/ $out/opt/
    '';

    nativeBuildInputs = [
      autoPatchelfHook
      zstd
      makeWrapper
    ];

    buildInputs = [
      alsa-lib # libasound.so.2
      curl
      fontconfig
      (lib.getLib stdenv.cc.cc) # libstdc++.so libgcc_s.so
      zlib
    ];

    runtimeDependencies = [
      libglvnd # for libegl
      libxkbcommon
      stdenv.cc.libc
      vulkan-loader
      xdg-utils
      xorg.libX11
      xorg.libxcb
      xorg.libXcursor
      xorg.libXi
      wayland
    ];

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -r opt usr/* $out

      # Enable Wayland support at runtime if running on Wayland
      # Check both WAYLAND_DISPLAY and XDG_SESSION_TYPE for Wayland detection
      wrapProgram $out/bin/warp-terminal-preview \
        --run 'if [ -n "$WAYLAND_DISPLAY" ] || [ "$XDG_SESSION_TYPE" = "wayland" ]; then export WARP_ENABLE_WAYLAND=1; fi'

      runHook postInstall
    '';

    postFixup = ''
      # Link missing libfontconfig to fix font discovery
      # https://github.com/warpdotdev/Warp/issues/5793
      patchelf \
        --add-needed libfontconfig.so.1 \
        $out/opt/warpdotdev/warp-terminal-preview/warp-preview
    '';
  });

  darwin = stdenvNoCC.mkDerivation (finalAttrs: {
    inherit pname meta passthru;
    inherit (versions.darwin) version;
    src = fetchurl {
      inherit (versions.darwin) hash;
      url = "https://releases.warp.dev/preview/v${finalAttrs.version}/WarpPreview.dmg";
    };

    sourceRoot = ".";

    nativeBuildInputs = [ undmg ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r *.app $out/Applications

      runHook postInstall
    '';
  });

  meta = with lib; {
    description = "Rust-based terminal (preview version with latest features)";
    homepage = "https://www.warp.dev";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [
      logger
    ];
    platforms = platforms.darwin ++ [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };

in
if stdenvNoCC.hostPlatform.isDarwin then darwin else linux
