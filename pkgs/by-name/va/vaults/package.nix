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
, wrapGAppsHook
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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "mpobaschnig";
    repo = "Vaults";
    rev = version;
    hash = "sha256-x7NoYQ+ol/j8LMazL4A0jDi/I4ajRNUzOpShLB0eHUg=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-fDUsbeJzgqjvNCNce1FnvvqZfXu0X5Knpan4Q+PYe+Q=";
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
    wrapGAppsHook
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
