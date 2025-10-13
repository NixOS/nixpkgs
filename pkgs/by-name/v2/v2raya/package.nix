{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchYarnDeps,
  symlinkJoin,

  yarnConfigHook,
  yarnBuildHook,
  nodejs,

  makeWrapper,
  v2ray,
  v2ray-geoip,
  v2ray-domain-list-community,
  nix-update-script,
}:
let
  pname = "v2raya";
  version = "2.2.7.3";

  src = fetchFromGitHub {
    owner = "v2rayA";
    repo = "v2rayA";
    tag = "v${version}";
    hash = "sha256-tgSZJGHkpQGhja5C62w6QpflYBBtt3rPCCPT+3yTzm4=";
    postFetch = "sed -i -e 's/npmmirror/yarnpkg/g' $out/gui/yarn.lock";
  };

  web = stdenv.mkDerivation {
    inherit pname version src;

    sourceRoot = "${src.name}/gui";

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/gui/yarn.lock";
      hash = "sha256-g+hI9n+nfXAcuEpjvDDaHg/DfjtNusOaw3S6kC1QDn4=";
    };

    env.OUTPUT_DIR = placeholder "out";

    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      nodejs
    ];
  };

  assetsDir = symlinkJoin {
    name = "assets";
    paths = [
      v2ray-geoip
      v2ray-domain-list-community
    ];
  };

in
buildGoModule {
  inherit pname version src;

  sourceRoot = "${src.name}/service";

  vendorHash = "sha256-uiURsB1V4IB77YKLu5gdaqw9Fuja6fC5adWYDE3OE+Q=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/v2rayA/v2rayA/conf.Version=${version}"
  ];

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  preBuild = ''
    cp -a ${web} server/router/web
  '';

  postInstall = ''
    install -Dm 444 ../install/universal/v2raya.desktop -t $out/share/applications
    install -Dm 444 ../install/universal/v2raya.png -t $out/share/icons/hicolor/512x512/apps
    substituteInPlace $out/share/applications/v2raya.desktop \
      --replace-fail 'Icon=/usr/share/icons/hicolor/512x512/apps/v2raya.png' 'Icon=v2raya'

    wrapProgram $out/bin/v2rayA \
      --prefix PATH ":" "${lib.makeBinPath [ v2ray ]}" \
      --prefix XDG_DATA_DIRS ":" ${assetsDir}/share
  '';

  passthru = {
    inherit web;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "web"
      ];
    };
  };

  meta = {
    description = "Linux web GUI client of Project V which supports V2Ray, Xray, SS, SSR, Trojan and Pingtunnel";
    homepage = "https://github.com/v2rayA/v2rayA";
    mainProgram = "v2rayA";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ChaosAttractor ];
  };
}
