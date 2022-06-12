{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, python3
, ninja
, pkg-config
, vala
, elementary-settings-daemon
, libgee
, granite
, gsettings-desktop-schemas
, gala
, gtk3
, glib
, polkit
, zeitgeist
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-security-privacy";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-jT8aYE36ZAeB9ng3RojVqxzmLtzpbsNRHPuDQ03XKcI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
  ];

  buildInputs = [
    elementary-settings-daemon # settings schema
    gala
    glib
    granite
    gsettings-desktop-schemas
    gtk3
    libgee
    polkit
    switchboard
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
    description = "Switchboard Security & Privacy Plug";
    homepage = "https://github.com/elementary/switchboard-plug-security-privacy";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };

}
