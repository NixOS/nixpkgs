{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, evolution-data-server
, glib
, granite
, gtk3
, libhandy
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-onlineaccounts";
  version = "6.5.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-7eKbOf5lD2zwmZc0k9PWGwnqaqXmwgJPmij0WtMT7Qk=";
  };

  patches = [
    # build: support evolution-data-server 3.45
    # https://github.com/elementary/switchboard-plug-onlineaccounts/pull/248
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-onlineaccounts/commit/08faf7b4241547b7900596af12a03d816712a808.patch";
      sha256 = "sha256-QLe+NPHuo3hLM9n1f4hT5IK4nkWtYSe91L1wVSBzw6k=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    evolution-data-server
    glib
    granite
    gtk3
    libhandy
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Online Accounts Plug";
    homepage = "https://github.com/elementary/switchboard-plug-onlineaccounts";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
