{ stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pantheon
, substituteAll
, meson
, ninja
, python3
, pkgconfig
, vala
, granite
, libgee
, gettext
, gtk3
, appstream
, gnome-menus
, json-glib
, elementary-dock
, bamf
, switchboard
, libunity
, libsoup
, wingpanel
, zeitgeist
, bc
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-applications-menu";
  version = "2.7.1";

  repoName = "applications-menu";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "sha256-NeazBzkbdQTC6OzPxxyED4OstMkNkUGtCIaZD67fTnM=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    appstream
    gettext
    meson
    ninja
    pkgconfig
    python3
    vala
   ];

  buildInputs = [
    bamf
    elementary-dock
    gnome-menus
    granite
    gtk3
    json-glib
    libgee
    libhandy
    libsoup
    libunity
    switchboard
    wingpanel
    zeitgeist
   ];

  mesonFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  patches = [
    # Port to Libhandy-1
    (fetchpatch {
      url = "https://github.com/elementary/applications-menu/commit/8eb2430e8513e9d37f875c5c9b8b15a968c27127.patch";
      sha256 = "8Uw9mUw7U5nrAwUDGVpAwoRqb9ah503wQCr9kPbBJIo=";
    })

    (substituteAll {
      src = ./fix-paths.patch;
      bc = "${bc}/bin/bc";
    })
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Lightweight and stylish app launcher for Pantheon";
    homepage = "https://github.com/elementary/applications-menu";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
