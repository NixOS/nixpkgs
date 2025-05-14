{
  lib,
  rustPlatform,

  fetchFromGitHub,
  fetchYarnDeps,

  cargo-tauri_1,
  cmake,
  nodejs,
  pkg-config,
  wrapGAppsHook3,
  yarn,
  yarnConfigHook,

  dbus,
  freetype,
  gtk3,
  libsoup_2_4,
  openssl,
  webkitgtk_4_0,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xplorer";
  version = "unstable-2023-03-19";

  src = fetchFromGitHub {
    owner = "kimlimjustin";
    repo = "xplorer";
    rev = "8d69a281cbceda277958796cb6b77669fb062ee3";
    hash = "sha256-VFRdkSfe2mERaYYtZlg9dvH1loGWVBGwiTRj4AoNEAo=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

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
    cp ${./Cargo.lock} src-tauri/Cargo.lock
  '';

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-H37vD0GTSsWV5UH7C6UANDWnExTGh8yqajLn3y7P2T8=";
  };

  nativeBuildInputs = [
    cargo-tauri_1.hook
    cmake
    nodejs
    pkg-config
    wrapGAppsHook3
    yarn
    yarnConfigHook
  ];

  buildInputs = [
    dbus
    freetype
    gtk3
    libsoup_2_4
    openssl
    webkitgtk_4_0
  ];

  preBuild = ''
    # upstream doesn't run this automatically
    yarn --offline run prebuild
  '';

  checkFlags = [
    # tries to mutate the parent directory
    "--skip=test_file_operation"
  ];

  meta = with lib; {
    description = "Customizable, modern file manager";
    homepage = "https://xplorer.space";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "xplorer";
  };
})
