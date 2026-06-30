{
  stdenv,
  lib,
  fetchurl,
  electron,
  makeWrapper,
  dpkg,
  ...
}:
let
  githubRepo = "https://github.com/Voxelum/x-minecraft-launcher";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xmcl";
  version = "0.59.1";

  src = fetchurl {
    # Use the deb file because there aren't resources like icons in the tarball.
    # However, the rpm file can be used as well.
    url = "${githubRepo}/releases/download/v${finalAttrs.version}/xmcl-${finalAttrs.version}-amd64.deb";
    sha256 = "1f68xy5kxp8sshn0bmhwq3rh4ihb8aygvwyadgik5bh776y3h9d8";
  };
  unpackPhase = "dpkg -x $src ./";

  strictDeps = true;
  __structuredAttrs = true;

  # Tools needed during the build process itself
  nativeBuildInputs = [
    dpkg # Unpacks the deb file
    makeWrapper # Creates wrapper scripts
  ];

  installPhase = ''
    runHook preInstall

    # Directly copying ./usr to $out will cause strange paths because of unknown reasons.
    mkdir -p $out/share
    cp -r ./usr/share/* $out/share

    mkdir -p $out/opt/xmcl
    cp -r ./opt/xmcl/resources/app.asar $out/opt/xmcl
    makeWrapper ${
      # Yes, XMCL uses Electron 29.3.1 instead of the latest version,
      # but 29.3.1 is too old to exist in nixpkgs.
      lib.getExe electron
    } $out/bin/xmcl \
      --argv0 "xmcl" \
      --add-flags "$out/opt/xmcl/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 

    # Substitute placeholder paths in the desktop file
    substituteInPlace $out/share/applications/xmcl.desktop --replace "Exec=/opt/xmcl/xmcl %U" "Exec=$out/bin/xmcl %U" 
                            
    runHook postInstall
  '';
  
  meta = {
    description = "An Open Source Minecraft Launcher with Modern UX";
    longDescription = ''
      XMCL is an Open Source Minecraft Launcher with Modern UX. 
      It provides a Disk Efficient way to manage all your Mods.
    '';
    homepage = githubRepo;
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
