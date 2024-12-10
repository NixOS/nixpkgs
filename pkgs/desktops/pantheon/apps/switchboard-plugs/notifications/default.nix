{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  vala,
  libgee,
  granite,
  gtk3,
  switchboard,
  elementary-notifications,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-notifications";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0zzhgs8m1y7ab31hbn7v8g8k7rx51gqajl243zmysn86lfqk8iay";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/switchboard-plug-notifications/pull/83
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-notifications/commit/2e0320aab62b6932e8ef5f941d02e244de381957.patch";
      sha256 = "0rcamasq837grck0i2yx6psggzrhv7p7m3mra5l0k9zsjxgar92v";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-notifications
    granite
    gtk3
    libgee
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Notifications Plug";
    homepage = "https://github.com/elementary/switchboard-plug-notifications";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
