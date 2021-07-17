{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, fetchpatch
, pantheon
, meson
, ninja
, pkg-config
, vala
, libgee
, granite
, gtk3
, switchboard
, elementary-notifications
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

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

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

  meta = with lib; {
    description = "Switchboard Notifications Plug";
    homepage = "https://github.com/elementary/switchboard-plug-notifications";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
