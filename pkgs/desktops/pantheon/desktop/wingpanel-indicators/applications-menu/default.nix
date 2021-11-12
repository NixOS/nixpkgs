{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, substituteAll
, meson
, ninja
, python3
, pkg-config
, vala
, granite
, libgee
, gettext
, gtk3
, gnome-menus
, json-glib
, elementary-dock
, bamf
, switchboard-with-plugs
, libsoup
, wingpanel
, zeitgeist
, bc
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-applications-menu";
  version = "2.9.1";

  repoName = "applications-menu";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "sha256-Q0ee8S8wWhK0Y16SWfE79Us6QD/oRE5Pxm3o//eb/po=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      bc = "${bc}/bin/bc";
    })
  ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    python3
    vala
  ];

  buildInputs = [
    bamf
    elementary-dock
    granite
    gtk3
    json-glib
    libgee
    libhandy
    libsoup
    switchboard-with-plugs
    wingpanel
    zeitgeist
  ] ++
  # applications-menu has a plugin to search switchboard plugins
  # see https://github.com/NixOS/nixpkgs/issues/100209
  # wingpanel's wrapper will need to pick up the fact that
  # applications-menu needs a version of switchboard with all
  # its plugins for search.
  switchboard-with-plugs.buildInputs;

  mesonFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
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
    description = "Lightweight and stylish app launcher for Pantheon";
    homepage = "https://github.com/elementary/applications-menu";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
