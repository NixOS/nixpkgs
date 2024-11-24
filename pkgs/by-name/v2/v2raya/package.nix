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
}:
let
  pname = "v2raya";
  version = "2.2.5.8";

  src = fetchFromGitHub {
    owner = "v2rayA";
    repo = "v2rayA";
    rev = "refs/tags/v${version}";
    hash = "sha256-yFN7mG5qS7BAuCSvSSZFFiyytd7XZ4kJvctc8cU72Oc=";
    postFetch = "sed -i -e 's/npmmirror/yarnpkg/g' $out/gui/yarn.lock";
  };

  web = stdenv.mkDerivation {
    inherit pname version src;

    sourceRoot = "${src.name}/gui";

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/gui/yarn.lock";
      hash = "sha256-AZIYkW2u1l9IaDpR9xiKNpc0sGAarLKwHf5kGnzdpKw=";
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

  vendorHash = "sha256-Oa7YmxcZr5scbhNeqGxJOkryL2uHQQ3RkLGWJaIXq3s=";

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

  meta = with lib; {
    description = "Linux web GUI client of Project V which supports V2Ray, Xray, SS, SSR, Trojan and Pingtunnel";
    homepage = "https://github.com/v2rayA/v2rayA";
    mainProgram = "v2rayA";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ChaosAttractor ];
  };
}
