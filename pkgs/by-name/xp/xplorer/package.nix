{ lib
, cmake
, dbus
, fetchFromGitHub
, fetchYarnDeps
, freetype
, gtk3
, libsoup_2_4
, stdenvNoCC
, yarnConfigHook
, yarnBuildHook
, nodejs
, openssl
, pkg-config
, rustPlatform
, webkitgtk_4_0
}:

let

  pname = "xplorer";
  version = "unstable-2023-03-19";

  src = fetchFromGitHub {
    owner = "kimlimjustin";
    repo = pname;
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

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-window-state-0.1.0" = "sha256-DkKiwBwc9jrxMaKWOyvl9nsBJW0jBe8qjtqIdKJmsnc=";
      "window-shadows-0.2.0" = "sha256-e1afzVjVUHtckMNQjcbtEQM0md+wPWj0YecbFvD0LKE=";
      "window-vibrancy-0.3.0" = "sha256-0psa9ZtdI0T6sC1RJ4GeI3w01FdO2Zjypuk9idI5pBY=";
    };
  };

  # copy the frontend static resources to final build directory
  # Also modify tauri.conf.json so that it expects the resources at the new location
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock

    mkdir -p frontend-build
    cp -R ${frontend-build}/src frontend-build

    substituteInPlace tauri.conf.json --replace '"distDir": "../out/src",' '"distDir": "frontend-build/src",'
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ dbus openssl freetype libsoup_2_4 gtk3 webkitgtk_4_0 ];

  checkFlags = [
    # tries to mutate the parent directory
    "--skip=test_file_operation"
  ];

  postInstall = ''
    mv $out/bin/app $out/bin/xplorer
  '';

  meta = with lib; {
    description = "Customizable, modern file manager";
    homepage = "https://xplorer.space";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "xplorer";
  };
}
