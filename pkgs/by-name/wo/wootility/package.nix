{
  stdenvNoCC,
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
  _7zz,
}:
let
  pname = "wootility";
  version = "5.4.3";

  x86_64-linux = fetchurl {
    url = "https://wooting.io/_backend/public/wootility/download?os=linux&version=${version}";
    hash = "sha256-eh2Ay4gvcxiDJCJ4nLXf4baZg5iyM+H+D7MJ+iDTWaQ=";
  };

  srcs = {
    inherit x86_64-linux;
    aarch64-linux = x86_64-linux;

    aarch64-darwin = fetchurl {
      url = "https://wooting.io/_backend/public/wootility/download?os=mac&platform=arm64&version=${version}";
      hash = "sha256-4zHxV8BH3soUU/d2YV69ZO1i8CCHeNQPFiFqrEi5Ki8=";
    };
  };

  throwSys = throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}";
  src = srcs.${stdenvNoCC.hostPlatform.system} or throwSys;

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://wooting.io/wootility";
    description = "Customization and management software for Wooting keyboards";
    changelog = "https://wooting.io/wootility/changelogs/${version}";
    platforms = lib.platforms.unix;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      sodiboo
      returntoreality
      FlorianFranzen
      debtquity
    ];
    mainProgram = "wootility";
  };

  linux = appimageTools.wrapType2 (finalAttrs: {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

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

  });

  darwin = stdenvNoCC.mkDerivation {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

    nativeBuildInputs = [
      _7zz
      makeWrapper
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r Wootility*/*.app $out/Applications

      makeWrapper "$out/Applications/Wootility.app/Contents/MacOS/Wootility" $out/bin/wootility

      runHook postInstall
    '';
  };
in
if stdenvNoCC.hostPlatform.isDarwin then darwin else linux
