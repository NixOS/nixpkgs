{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  electron,
  python3,
}:

let
  version = "1.2.49";
  electronSrc = fetchFromGitHub {
    owner = "threema-ch";
    repo = "threema-web-electron";
    tag = version;
    hash = "sha256-8Zy+LMxszqCT17FFz8sEMAtBSTXhU/F2Nz9MfEA82xw=";
  };

  threema-web = buildNpmPackage rec {
    pname = "threema-web";
    version = "2.6.2";

    src = fetchFromGitHub {
      owner = "threema-ch";
      repo = "threema-web";
      tag = "v${version}";
      hash = "sha256-GmyWKJdDgiRS7XxNjCyvt92Bn48kpP3+ZsfRouyUCM0=";
    };

    npmDepsHash = "sha256-KDkJ2jdtHVK40b0ja/Nj6t5Bcl5frh7rzteWD74AKOM=";
    npmBuildScript = "dist";

    nativeBuildInputs = [
      (python3.withPackages (ps: [ ps.setuptools ])) # Used by gyp
    ];

    patches = [
      "${electronSrc}/tools/patches/patch-user-agent.patch"
      "${electronSrc}/tools/patches/patch-looks.patch"
    ];

    postInstall = ''
      # Content of ${electronSrc}/tools/patches/post-patch-threema-web.sh
      export threema_web_version=threema-web-${version}
      sed -i.bak -E "s/IN_MEMORY_SESSION_PASSWORD:(true|false|0|1|\!0|\!1)/IN_MEMORY_SESSION_PASSWORD:true/g" -- release/$threema_web_version/*.bundle.js
      cp -r . "$out"
    '';
  };

  consumer = buildNpmPackage rec {
    pname = "threema-desktop-consumer";
    inherit version;
    src = electronSrc;
    sourceRoot = "${src.name}/app";
    npmDepsHash = "sha256-Nn1WIyGRAG009GlJIedl0QUeKLalY+H3Mj8w4J1GE6I=";
    env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    dontNpmBuild = true;
    prePatch = ''
      rm -r dependencies/threema-web
      cp -r ${threema-web} dependencies/threema-web
      chmod +w dependencies/threema-web
    '';
    postInstall = ''
      cp -r . "$out"
    '';
  };

in
buildNpmPackage rec {
  pname = "threema-desktop";
  inherit version;
  src = electronSrc;

  npmDepsHash = "sha256-i37rIAIhoIU9tnioyhPFR1GWBfygMREZ0HCYE7ujXuE=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postPatch = ''
    rm -r app
    cp -r ${consumer} app
    chmod +w app
  '';

  npmBuildScript = "app:build:electron:main";

  # We need to install the consumer
  dontNpmInstall = true;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "threema-desktop";
      exec = meta.mainProgram;
      icon = "threema";
      desktopName = "Threema Desktop";
      comment = meta.description;
    })
  ];

  postInstall = ''
    mkdir -p $out/opt
    cp -r app $out/opt/threema

    for dir in assets dependencies; do
      ln -s $out/opt/threema/$dir $out/opt/threema/dist/src/$dir
    done

    mkdir -p $out/share/pixmaps
    cp $out/opt/threema/assets/icons/svg/consumer.svg $out/share/pixmaps/threema.svg

    makeWrapper ${electron}/bin/electron $out/bin/threema \
      --add-flags $out/opt/threema/dist/src/main.js
  '';

  meta = {
    description = "Desktop client for Threema, a privacy-focused end-to-end encrypted mobile messenger";
    homepage = "https://threema.ch";
    license = lib.licenses.agpl3Only;
    mainProgram = "threema";
    maintainers = [ lib.maintainers.jonhermansen ];
    platforms = [ "x86_64-linux" ];
  };
}
