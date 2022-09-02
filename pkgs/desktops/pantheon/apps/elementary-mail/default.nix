{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, ninja
, python3
, vala
, gtk3
, libxml2
, libhandy
, webkitgtk
, folks
, libgdata
, sqlite
, glib-networking
, granite
, evolution-data-server
, wrapGAppsHook
, libgee
}:

stdenv.mkDerivation rec {
  pname = "elementary-mail";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "mail";
    rev = version;
    sha256 = "sha256-DO3nybH7tb/ISrSQ3+Oj612m64Ov6X0GAWePMbKjCc4=";
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    evolution-data-server
    folks
    glib-networking
    granite
    gtk3
    libgdata
    libgee
    libhandy
    sqlite
    webkitgtk
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
    description = "Mail app designed for elementary OS";
    homepage = "https://github.com/elementary/mail";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ethancedwards8 ] ++ teams.pantheon.members;
    mainProgram = "io.elementary.mail";
  };
}
