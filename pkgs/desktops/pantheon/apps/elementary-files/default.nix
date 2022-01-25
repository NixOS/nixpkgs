{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pkg-config
, meson
, ninja
, gettext
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
, libdbusmenu-gtk3
, zeitgeist
, glib-networking
, elementary-icon-theme
, libcloudproviders
, libgit2-glib
, wrapGAppsHook
, systemd
}:

stdenv.mkDerivation rec {
  pname = "elementary-files";
  version = "6.1.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "files";
    rev = version;
    sha256 = "sha256-5TSzV8MQG81aCCR8yiCPhKJaLrp/fwf4mjP32KkcbbY=";
  };

  patches = [
    # Fix build with meson 0.61
    # https://github.com/elementary/files/pull/1973
    (fetchpatch {
      url = "https://github.com/elementary/files/commit/28428fbda905ece59d3427a3a40e986fdf71a916.patch";
      sha256 = "sha256-GZTHAH9scQWrBqdrDI14cj57f61HD8o79zFcPCXjKmc=";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    glib-networking
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
    elementary-icon-theme
    glib
    granite
    gtk3
    libcanberra
    libcloudproviders
    libdbusmenu-gtk3
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
