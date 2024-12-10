{
  lib,
  cargo-tauri,
  cmake,
  dbus,
  fetchgit,
  fetchYarnDeps,
  freetype,
  gsettings-desktop-schemas,
  gtk3,
  libsoup,
  mkYarnPackage,
  openssl,
  pkg-config,
  rustPlatform,
  webkitgtk,
  wrapGAppsHook3,
  sqlite,
}:

let
  pname = "treedome";
  version = "0.4.5";

  src = fetchgit {
    url = "https://codeberg.org/solver-orgz/treedome";
    rev = version;
    hash = "sha256-YkyjG/ee5WeO5OD4FZnWaqcOJO3YC0uQkbwGkCNBxC8=";
    fetchLFS = true;
  };

  frontend-build = mkYarnPackage {
    inherit version src;
    pname = "treedome-ui";

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/yarn.lock";
      hash = "sha256-CrD/n8z5fJKkBKEcvpRHJaqXBt1gbON7VsuLb2JGu1A=";
    };

    packageJSON = ./package.json;

    configurePhase = ''
      runHook preConfigure
      ln -s $node_modules node_modules
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      yarn --offline run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/dist
      cp -r dist/** $out/dist

      runHook postInstall
    '';

    doDist = false;
  };
in
rustPlatform.buildRustPackage {
  inherit version pname src;
  sourceRoot = "${src.name}/src-tauri";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "fix-path-env-0.0.0" = "sha256-ewE3CwqLC8dvi94UrQsWbp0mjmrzEJIGPDYtdmQ/sGs=";
    };
  };

  env = {
    VERGEN_GIT_DESCRIBE = version;
  };

  preConfigure = ''
    mkdir -p dist
    cp -R ${frontend-build}/dist/** dist
  '';

  # copy the frontend static resources to final build directory
  # Also modify tauri.conf.json so that it expects the resources at the new location
  postPatch = ''
    substituteInPlace ./tauri.conf.json \
      --replace '"distDir": "../dist",' '"distDir": "dist",' \
      --replace '"beforeBuildCommand": "yarn run build",' '"beforeBuildCommand": "",'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    cargo-tauri
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus
    openssl
    freetype
    libsoup
    gtk3
    webkitgtk
    gsettings-desktop-schemas
    sqlite
  ];

  buildPhase = ''
    runHook preBuild

    cargo tauri build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/
    mkdir -p $out/share/

    cp target/release/bundle/deb/treedome_0.0.0_amd64/data/usr/bin/treedome $out/bin/treedome
    cp -R target/release/bundle/deb/treedome_0.0.0_amd64/data/usr/share/** $out/share/

    runHook postInstall
  '';

  # WEBKIT_DISABLE_COMPOSITING_MODE essential in NVIDIA + compositor https://github.com/NixOS/nixpkgs/issues/212064#issuecomment-1400202079
  postFixup = ''
    wrapProgram "$out/bin/treedome" \
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
  '';

  meta = with lib; {
    description = "A local-first, encrypted, note taking application organized in tree-like structures";
    homepage = " https://codeberg.org/solver-orgz/treedome";
    license = licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "treedome";
    maintainers = with maintainers; [ tengkuizdihar ];
    changelog = "https://codeberg.org/solver-orgz/treedome/releases/tag/${version}";
  };
}
