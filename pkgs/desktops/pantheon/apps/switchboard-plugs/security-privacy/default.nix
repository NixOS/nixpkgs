{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, python3
, ninja
, pkg-config
, vala
, libgee
, granite
, gtk3
, glib
, polkit
, zeitgeist
, switchboard
, lightlocker
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-security-privacy";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1ydr1xpbyxjcnd36c9j7a64srbz6gpbshwhcqj6591kmiqhmvknk";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
  ];

  buildInputs = [
    glib
    granite
    gtk3
    libgee
    polkit
    switchboard
    lightlocker
    zeitgeist
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "Switchboard Security & Privacy Plug";
    homepage = "https://github.com/elementary/switchboard-plug-security-privacy";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };

}
