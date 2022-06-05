{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, ninja
, vala
, glib
, gtk3
, libgee
, desktop-file-utils
, geoclue2
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "pantheon-agent-geoclue2";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0hx3sky0vd2vshkscy3w5x3s18gd45cfqh510xhbmvc0sa32q9gd";
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
    geoclue2
    gtk3
    libgee
  ];

  # This should be provided by a post_install.py script - See -> https://github.com/elementary/pantheon-agent-geoclue2/pull/21
  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Pantheon Geoclue2 Agent";
    homepage = "https://github.com/elementary/pantheon-agent-geoclue2";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
