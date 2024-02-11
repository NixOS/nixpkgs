{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, ninja
, vala
, desktop-file-utils
, libcanberra
, gtk3
, glib
, libgee
, libhandy
, granite
, pango
, bamf
, sqlite
, zeitgeist
, libcloudproviders
, libgit2-glib
, wrapGAppsHook
, systemd
}:

stdenv.mkDerivation rec {
  pname = "elementary-files";
  version = "6.5.3";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "files";
    rev = version;
    sha256 = "sha256-geJLHRo1Bd2oFT+UtirHj9FVSFTFMK/v/5h+NF9woFo=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    bamf
    glib
    granite
    gtk3
    libcanberra
    libcloudproviders
    libgee
    libgit2-glib
    libhandy
    pango
    sqlite
    systemd
    zeitgeist
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "File browser designed for elementary OS";
    homepage = "https://github.com/elementary/files";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.files";
  };
}
