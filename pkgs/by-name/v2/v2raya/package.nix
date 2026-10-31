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
  v2ray-geoip,
  v2ray-domain-list-community,
  nix-update-script,
}:
let
  pname = "v2raya";
  version = "2.4.25";

  src = fetchFromGitHub {
    owner = "v2rayA";
    repo = "v2rayA";
    tag = "v${version}";
    hash = "sha256-n/traD1xAFBnhaff5Cu+dKIHvYvPB++gONBEXm9MoqY=";
    postFetch = "sed -i -e 's/npmmirror/yarnpkg/g' $out/gui/yarn.lock";
  };

  web = stdenv.mkDerivation {
    inherit pname version src;

    sourceRoot = "${src.name}/gui";

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/gui/yarn.lock";
      hash = "sha256-cKmRKBaUpSeEJJ9GtaSjF+S74dSHt4lUwIYmTl1uPNw=";
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

  core = buildGoModule {
    pname = "v2raya-core";
    inherit version src;

    sourceRoot = "${src.name}/core";

    vendorHash = "sha256-p7KKcpFw+NcPZulm9AE/0eZXoC0g2Dsb+4VpbujHnHU=";

    ldflags = [
      "-s"
      "-w"
      "-X main.Version=${version}"
    ];

    subPackages = [ "./main" ];

    postInstall = ''
      mv $out/bin/main $out/bin/v2raya_core
    '';
  };

in
buildGoModule {
  inherit pname version src;

  sourceRoot = "${src.name}/service";

  vendorHash = "sha256-SmD73GK+BjN3fa++Vki2HklY5MwiMnv5cCrUoT9y6XY=";

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
      --prefix PATH ":" "${lib.makeBinPath [ core ]}" \
      --prefix XDG_DATA_DIRS ":" ${assetsDir}/share
  '';

  passthru = {
    inherit core web;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "core"
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
