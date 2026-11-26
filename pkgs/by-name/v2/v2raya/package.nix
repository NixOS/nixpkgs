{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchYarnDeps,
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
  version = "2.5.16";

  src = fetchFromGitHub {
    owner = "v2rayA";
    repo = "v2rayA";
    tag = "v${version}";
    hash = "sha256-+nqGhb3cOH/gwdRl41FQ6nsYTiS4uia960MKDox3QaQ=";
  };

  core = buildGoModule {
    pname = "${pname}-core";
    inherit version src;

    sourceRoot = "${src.name}/core";

    vendorHash = "sha256-0jMl0unNB5Atau+yKO7n4bR/Y1qzOKSG16S0Cu4lDz8=";

    subPackages = [ "./main" ];

    env.CGO_ENABLED = "0";

    ldflags = [
      "-s"
      "-w"
      "-X main.Version=${version}"
    ];

    postInstall = ''
      mv $out/bin/main $out/bin/v2raya_core
    '';
  };

  web = stdenv.mkDerivation {
    inherit pname version src;

    sourceRoot = "${src.name}/gui";

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/gui/yarn.lock";
      mirrorUrl = "https://registry.npmjs.org/";
      hash = "sha256-7HAmziWqrJ3uASgN/CCMdBHxBAOk6O30z3KJ3QCNMM8=";
    };

    env.OUTPUT_DIR = placeholder "out";

    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      nodejs
    ];
  };
in
buildGoModule {
  inherit pname version src;

  sourceRoot = "${src.name}/service";

  vendorHash = "sha256-PE36aAmvazZVsFCmkYfEQe05/pWiE4CiEgtVnVBqqEs=";

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
    mv $out/bin/v2rayA $out/bin/v2raya
    install -Dm755 ${core}/bin/v2raya_core $out/bin/v2raya_core

    mkdir -p $out/share/v2raya
    ln -s ${v2ray-geoip}/share/v2ray/geoip.dat \
      $out/share/v2raya/geoip.dat
    ln -s ${v2ray-domain-list-community}/share/v2ray/geosite.dat \
      $out/share/v2raya/geosite.dat

    wrapProgram $out/bin/v2raya \
      --set V2RAYA_V2RAY_ASSETSDIR "$out/share/v2raya"

    install -Dm 444 ../install/universal/v2raya.desktop -t $out/share/applications
    install -Dm 444 ../install/universal/v2raya.png -t $out/share/icons/hicolor/512x512/apps
    substituteInPlace $out/share/applications/v2raya.desktop \
      --replace-fail 'Icon=/usr/share/icons/hicolor/512x512/apps/v2raya.png' 'Icon=v2raya'
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
    mainProgram = "v2raya";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ChaosAttractor ];
  };
}
