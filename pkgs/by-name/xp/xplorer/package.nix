{
  lib,
  cmake,
  dbus,
  fetchFromGitHub,
  fetchYarnDeps,
  freetype,
  gtk3,
  libsoup_2_4,
  stdenvNoCC,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  openssl,
  pkg-config,
  rustPlatform,
}:

let

  pname = "xplorer";
  version = "unstable-2023-03-19";

  src = fetchFromGitHub {
    owner = "kimlimjustin";
    repo = "xplorer";
    rev = "8d69a281cbceda277958796cb6b77669fb062ee3";
    sha256 = "sha256-VFRdkSfe2mERaYYtZlg9dvH1loGWVBGwiTRj4AoNEAo=";
  };

  frontend-build = stdenvNoCC.mkDerivation (finalAttrs: {
    inherit version src;
    pname = "xplorer-ui";

    offlineCache = fetchYarnDeps {
      yarnLock = src + "/yarn.lock";
      sha256 = "sha256-H37vD0GTSsWV5UH7C6UANDWnExTGh8yqajLn3y7P2T8=";
    };
    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      nodejs
    ];
    yarnBuildScript = "prebuild";
    installPhase = ''
      cp -r out $out
    '';
  });
in

rustPlatform.buildRustPackage {
  inherit version src pname;

  sourceRoot = "${src.name}/src-tauri";

  cargoHash = "sha256-D7qgmxDYQEgOkEYKDSLA875bXeTKDvAntF7kB4esn24=";

  # copy the frontend static resources to final build directory
  # Also modify tauri.conf.json so that it expects the resources at the new location
  postPatch = ''
    mkdir -p frontend-build
    cp -R ${frontend-build}/src frontend-build

    substituteInPlace tauri.conf.json --replace '"distDir": "../out/src",' '"distDir": "frontend-build/src",'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    dbus
    openssl
    freetype
    libsoup_2_4
    gtk3
    # webkitgtk_4_0
  ];

  checkFlags = [
    # tries to mutate the parent directory
    "--skip=test_file_operation"
  ];

  postInstall = ''
    mv $out/bin/app $out/bin/xplorer
  '';

  meta = with lib; {
    # webkitgtk_4_0 was removed
    broken = true;
    description = "Customizable, modern file manager";
    homepage = "https://xplorer.space";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "xplorer";
  };
}
