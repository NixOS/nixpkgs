{
  lib,
  stdenvNoCC,
  appimageTools,
  fetchurl,
  makeWrapper,
  undmg,
}:

let
  pname = "tutanota-desktop";
  version = "361.260929.0";

  linuxSrc = fetchurl {
    url = "https://github.com/tutao/tutanota/releases/download/tutanota-desktop-release-${version}/tutanota-desktop-linux.AppImage";
    hash = "sha256-cdk7Fn8j5mm1h8tWFVF8AYsBvWR3ELlfDl6+Bjyw8YQ=";
  };

  darwinSrc = fetchurl {
    url = "https://github.com/tutao/tutanota/releases/download/tutanota-desktop-release-${version}/tutanota-desktop-mac.dmg";
    hash = "sha256-bApJuHGTB9I3G0pG/3uU0MYhCgA4uAzrfe31izzY65I=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Tuta official desktop client";
    homepage = "https://tuta.com/";
    changelog = "https://github.com/tutao/tutanota/releases/tag/tutanota-desktop-release-${version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ s0ssh ];
    mainProgram = "tutanota-desktop";
    platforms = lib.platforms.darwin ++ [ "x86_64-linux" ];
  };

  linux = appimageTools.wrapType2 {
    inherit
      pname
      version
      passthru
      meta
      ;
    src = linuxSrc;

    extraPkgs = pkgs: [ pkgs.libsecret ];

    nativeBuildInputs = [ makeWrapper ];

    extraInstallCommands =
      let
        appimageContents = appimageTools.extract {
          inherit pname version;
          src = linuxSrc;
        };
      in
      ''
        install -Dm 444 ${appimageContents}/tutanota-desktop.desktop -t $out/share/applications
        cp -r ${appimageContents}/usr/share/icons/. $out/share/icons

        substituteInPlace $out/share/applications/tutanota-desktop.desktop \
          --replace 'Exec=AppRun' 'Exec=${pname}'

        wrapProgram $out/bin/tutanota-desktop \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
      '';
  };

  darwin = stdenvNoCC.mkDerivation {
    inherit
      pname
      version
      passthru
      meta
      ;
    src = darwinSrc;

    sourceRoot = ".";

    nativeBuildInputs = [
      undmg
      makeWrapper
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications"
      cp -R "Tuta Mail.app" "$out/Applications/"
      makeWrapper "$out/Applications/Tuta Mail.app/Contents/MacOS/Tuta Mail" "$out/bin/tutanota-desktop"

      runHook postInstall
    '';
  };
in
if stdenvNoCC.hostPlatform.isDarwin then darwin else linux
