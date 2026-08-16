{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
}:

let
  pname = "wootility";
  version = "5.4.1";
  src = fetchurl {
    url = "https://wootility-updates.ams3.cdn.digitaloceanspaces.com/wootility-linux/Wootility-${version}.AppImage";
    sha256 = "sha256-QqkkfLi0teDH5E0mm4hnY42msgE/z1RV1Rl4+Tt+TaQ=";
  };
in

appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      wrapProgram $out/bin/wootility \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

      install -Dm444 ${contents}/wootility.desktop -t $out/share/applications
      install -Dm444 ${contents}/wootility.png -t $out/share/icons
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
    ];
    mainProgram = "wootility";
  };
}
