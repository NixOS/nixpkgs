{ stdenv
, fetchFromGitHub
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
, plank
, bamf
, switchboard
, libunity
, libsoup
, wingpanel
, zeitgeist
, bc
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-applications-menu";
  version = "2.6.0";

  repoName = "applications-menu";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "16ki1x6697jmfqajynx2zvwqrpjpshnd08y7vf6g7xc7zwwh38c5";
  };

  passthru = {
    updateScript = pantheon.updateScript {
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
    gnome-menus
    granite
    gtk3
    json-glib
    libgee
    libsoup
    libunity
    plank
    switchboard
    wingpanel
    zeitgeist
   ];

  mesonFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  patches = [
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
