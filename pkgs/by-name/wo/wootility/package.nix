{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "wootility";
  version = "5.4.2";
  src = fetchurl {
    url = "https://wootility-updates.ams3.cdn.digitaloceanspaces.com/wootility-linux/Wootility-${finalAttrs.version}.AppImage";
    hash = "sha512-3n73cnXW81w+7ta6+nnPymEriU9CpfKwX8DFNuxuNMMEBCyL6YgpQmxa0qKY6hr9WiiHQyuqvrSe+bXURwv31w==";
  };

  passthru.updateScript = ./update.sh;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    wrapProgram $out/bin/wootility \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -Dm444 ${finalAttrs.contents}/wootility.desktop -t $out/share/applications
    install -Dm444 ${finalAttrs.contents}/wootility.png -t $out/share/icons
    substituteInPlace $out/share/applications/wootility.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox' 'Exec=wootility'
  '';

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  extraPkgs =
    pkgs: with pkgs; [
      libxkbfile
    ];

  meta = {
    homepage = "https://wooting.io/wootility";
    description = "Customization and management software for Wooting keyboards";
    platforms = lib.platforms.linux;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      sodiboo
      returntoreality
      FlorianFranzen
    ];
    mainProgram = "wootility";
  };
})
