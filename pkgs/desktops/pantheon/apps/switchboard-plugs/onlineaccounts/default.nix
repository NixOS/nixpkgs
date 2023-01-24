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
    # https://github.com/elementary/switchboard-plug-onlineaccounts/pull/244
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-onlineaccounts/commit/b60f0458a23a2f76ad14d399f145e150e1ab82d3.patch";
      sha256 = "sha256-C7woN4shPrVlSWZeW0Fz+xFi5CTQd2K5BsF5YeI9x0Y=";
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
