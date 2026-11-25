{
  lib,
  symlinkJoin,
  makeWrapper,
  stdenvNoCC,
  fetchurl,
  fetchFromGitHub,
  v2ray-geoip,
  v2ray-domain-list-community,
}:
let
  pname = "v2raya-bin";
  version = "2.5.16";

  src = fetchurl {
    url = "https://github.com/v2rayA/v2rayA/releases/download/v2.5.16/v2raya_linux_x64_2.5.16";
    hash = "sha256-YmqHuj+8yyaIUp3758h4FnHiZD5N7S0H4uDIAN+GPCw=";
  };

  coreSrc = fetchurl {
    url = "https://github.com/v2rayA/v2rayA/releases/download/v2.5.16/v2raya_core_linux_x64_2.5.16";
    hash = "sha256-ae3yEAXCmCVKInaSN+g0OLIrHvAB5VMuSnQ5bQ5LnZ0=";
  };

  assetsDir = symlinkJoin {
    name = "${pname}-assets";
    paths = [
      v2ray-geoip
      v2ray-domain-list-community
    ];
  };

  desktopSrc = fetchFromGitHub {
    owner = "v2rayA";
    repo = "v2rayA";
    rev = "v${version}";
    hash = "sha256-XCFsmie9K1l6BsFehjA9+Dbsdb5mfaPWVu5cceRHysw=";
  };
in
stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    src
    coreSrc
    ;

  __structuredAttrs = true;

  strictDeps = true;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 "$src" "$out/bin/v2raya"
    install -Dm755 "$coreSrc" "$out/bin/v2raya_core"

    install -Dm644 ${desktopSrc}/install/universal/v2raya.desktop \
      $out/share/applications/v2raya.desktop

    install -Dm644 ${desktopSrc}/install/universal/v2raya.png \
      $out/share/icons/hicolor/512x512/apps/v2raya.png

    substituteInPlace $out/share/applications/v2raya.desktop \
      --replace-fail \
        'Icon=/usr/share/icons/hicolor/512x512/apps/v2raya.png' \
        'Icon=v2raya'

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/v2raya \
      --set V2RAYA_V2RAY_ASSETSDIR "${assetsDir}/share/v2ray"
  '';

  passthru.assetsDir = assetsDir;

  meta = {
    description = "Linux web GUI client of Project V which supports V2Ray, Xray, SS, SSR, Trojan and Pingtunnel";
    homepage = "https://github.com/v2rayA/v2raya";
    mainProgram = "v2raya";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ pouya ];
  };
}
