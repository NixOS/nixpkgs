{
  stdenv,
  lib,
  fetchFromGitHub,
  electron,
  makeWrapper,
  pnpm_10, # XMCL uses 10.33.3
  makeDesktopItem,
  fetchPnpmDeps,
  copyDesktopItems,
  ...
}:
let
  execPlaceholder = "TO_BE_REPLACED";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xmcl";
  version = "0.61.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Voxelum";
    repo = "x-minecraft-launcher";
    rev = "22a37c31aca0266fd4e91e22f1540e7c15a2c521";
    hash = "sha256-mQ2HvB4W4pC4Keb4ex4mUUSpzYgiUFEjXZGvZl/SKkc=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-Yuxuqr1BiviSw+dGNHLs2jAy8ADlBvRks6Kmy7FmCMw=";
  };

  # Tools needed during the build process itself
  nativeBuildInputs = [
    makeWrapper # Creates wrapper scripts
    copyDesktopItems
  ];

  buildPhase = ''
    runHook preBuild

    pnpm build:renderer
    NODE_ENV=production pnpm run --prefix=xmcl-electron-app compile

    runHook postBuild
  '';

  # Though the desktop file can be generated from config in {xmcl}/electron-builder.ts,
  # manually writing here is a more simple way.
  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      desktopName = "X Minecraft Launcher";
      exec = execPlaceholder;
      terminal = false;
      icon = finalAttrs.pname;
      startupWMClass = finalAttrs.pname;
      mimeTypes = [ "x-scheme-handler/${finalAttrs.pname}" ];
      comment = finalAttrs.meta.description;
      categories = [
        "Game"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r ./xmcl-electron-app/dist $out/opt/xmcl

    makeWrapper ${
      # Yes, XMCL uses Electron 29.3.1 instead of the latest version,
      # but 29.3.1 is too old to exist in nixpkgs.
      lib.getExe electron
    } $out/bin/xmcl \
      --argv0 "xmcl" \
      --add-flags "$out/opt/xmcl" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 

    runHook postInstall

    # Yes, after postInstall
    # Substitute placeholder paths in the desktop file
    substituteInPlace $out/share/applications/xmcl.desktop --replace-warn "Exec=${execPlaceholder}" "Exec=$out/bin/xmcl %U"                  
  '';

  # It's downloaded from a *normal* url instead of a GitHub repository.
  #passthru.updateScript = nix-update-script { };
  meta = {
    description = "An Open Source Minecraft Launcher with Modern UX";
    longDescription = ''
      XMCL is an Open Source Minecraft Launcher with Modern UX. 
      It provides a Disk Efficient way to manage all your Mods.
    '';
    homepage = "https://xmcl.app/";
    mainProgram = "xmcl";
    license = lib.licenses.mit;
    # XMCL does supports MacOS, but I haven't any darwin devices for test.
    platforms = lib.lists.filter (
      platform: lib.strings.hasSuffix "linux" platform
    ) electron.meta.platforms;
    maintainers = with lib.maintainers; [
      Neila
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
