{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
}:

let
  pname = "wootility";
<<<<<<< HEAD
  version = "5.2.2";
  src = fetchurl {
    url = "https://wootility-updates.ams3.cdn.digitaloceanspaces.com/wootility-linux/Wootility-${version}.AppImage";
    sha256 = "sha256-0ROk+Qv874zxoHFznWbdVYSwdui5XNqHGu5hcWzo4Wg=";
=======
  version = "5.1.2";
  src = fetchurl {
    url = "https://wootility-updates.ams3.cdn.digitaloceanspaces.com/wootility-linux/Wootility-${version}.AppImage";
    sha256 = "sha256-JcVyuilhy1qjXyIeniXZ0s4qxXr/4wLXrXgTTxjCkBk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
      install -Dm444 ${contents}/Wootility.desktop -t $out/share/applications
      install -Dm444 ${contents}/Wootility.png -t $out/share/pixmaps
      substituteInPlace $out/share/applications/Wootility.desktop \
=======
      install -Dm444 ${contents}/wootility.desktop -t $out/share/applications
      install -Dm444 ${contents}/wootility.png -t $out/share/pixmaps
      substituteInPlace $out/share/applications/wootility.desktop \
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        --replace-fail 'Exec=AppRun --no-sandbox' 'Exec=wootility'
    '';

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  extraPkgs =
    pkgs: with pkgs; [
      xorg.libxkbfile
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
