{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pkg-config
, meson
, ninja
, vala
, python3
, desktop-file-utils
, libcanberra
, gtk3
, glib
, libgee
, libhandy
, granite
, libnotify
, pango
, elementary-dock
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
  version = "6.2.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "files";
    rev = version;
    sha256 = "sha256-pJFeMG2aGaMkS00fSoRlMR2YSg5YzwqwaQT8G7Gk5S4=";
  };

  patches = [
    # Ensure special user directory icon used for bookmark
    # https://github.com/elementary/files/pull/2106
    (fetchpatch {
      url = "https://github.com/elementary/files/commit/00b1c2a975aeab378ed6eb1d90c8988f82596add.patch";
      sha256 = "sha256-F/Vk7dg57uBBMO4WOJ/7kKbRNMZuWZ3QfrBfEIBozbw=";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    bamf
    elementary-dock
    glib
    granite
    gtk3
    libcanberra
    libcloudproviders
    libgee
    libgit2-glib
    libhandy
    libnotify
    pango
    sqlite
    systemd
    zeitgeist
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
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
