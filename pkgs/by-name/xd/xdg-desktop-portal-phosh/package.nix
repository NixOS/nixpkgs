{
  stdenv,
  lib,
  fetchFromGitLab,
  gnome-desktop,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  xdg-desktop-portal,
  rustc,
  desktop-file-utils,
  cargo,
  rustPlatform,
  gettext,
}:
let
  # Derived from subprojects/pfs.wrap
  pfs = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "guidog";
    repo = "pfs";
    tag = "v0.0.4";
    hash = "sha256-b0S/jNE03h26bGA76fb/qlyJ8/MifZeltTc16UX2h9w=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-phosh";
  version = "0.49.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "guidog";
    repo = "xdg-desktop-portal-phosh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VF+ZNUP5Y2xm2nlNN3QsLJh8yNRJH7d3k+kLJ+4eu9s=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-h+VQqtirReLIHlVByKSb6DpqR1FtCxSwQpjowHX1mcg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustc
    desktop-file-utils
    cargo
    rustPlatform.cargoSetupHook
    gettext
  ];

  buildInputs = [
    libadwaita
    gnome-desktop
    xdg-desktop-portal
  ];

  strictDeps = true;

  prePatch = ''
    cp -r ${pfs} subprojects/pfs
    chmod +w -R subprojects/pfs # Allow patches for subprojects to work
  '';

  patches = [
    # Patch that fixes the issue with two Rust package versions.
    # For reasons that I don't understand, rustPlatform.fetchCargoVendor seems to not fetch the version inside the Cargo.lock file.
    # Like with libadwaita, fetchCargoVendor download the version 0.7.2 but in the lock file specified 0.7.1 and in the toml file specified 0.7.
    ./cargo_lock_deps_version.patch
  ];

  meta = with lib; {
    description = "A backend implementation for xdg-desktop-portal that is using GTK/GNOME/Phosh to provide interfaces that aren't provided by the GTK portal";
    homepage = "https://gitlab.gnome.org/guidog/xdg-desktop-portal-phosh";
    changelog = "https://gitlab.gnome.org/guidog/xdg-desktop-portal-phosh/-/blob/main/NEWS";
    maintainers = with maintainers; [ armelclo ];
    platforms = platforms.linux;
    license = licenses.gpl3Only;
  };
})
