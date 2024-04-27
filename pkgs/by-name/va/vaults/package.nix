{ fetchFromGitHub
, lib
, stdenv
, appstream-glib
, desktop-file-utils
, meson
, ninja
, pkg-config
, python3
, rustPlatform
, rustc
, cargo
, wrapGAppsHook3
, glib
, gtk4
, libadwaita
, wayland
, gocryptfs
, cryfs
, cmake
}:

stdenv.mkDerivation rec {
  pname = "vaults";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "mpobaschnig";
    repo = "Vaults";
    rev = version;
    hash = "sha256-jA7OeyRqc5DxkS4sMx9cIbVlZwd++aCQi09uBQik1oA=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-l9Zer6d6kgjIUNiQ1VdQQ57caVNWfzCkdsMf79X8Ar4=";
  };

  postPatch = ''
    patchShebangs build-aux
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ gocryptfs cryfs ]}"
    )
  '';

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    appstream-glib
    gtk4
    python3
    glib
    libadwaita
    wayland
    gocryptfs
    cryfs
  ];

  meta = {
    description = "GTK frontend for encrypted vaults supporting gocryptfs and CryFS for encryption";
    homepage = "https://mpobaschnig.github.io/vaults/";
    changelog = "https://github.com/mpobaschnig/vaults/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ benneti ];
    mainProgram = "vaults";
    platforms = lib.platforms.linux;
  };
}
