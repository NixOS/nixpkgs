{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, fetchpatch
, pantheon
, meson
, ninja
, pkgconfig
, vala
, libgee
, granite
, gtk3
, cups
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-printers";
  version = "2.1.9";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-tnAJyyPN/Xy1pmlgBpgO2Eb5CeHrRltjQTHmuTPBt8s=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    cups
    granite
    gtk3
    libgee
    switchboard
  ];

  meta = with lib; {
    description = "Switchboard Printers Plug";
    homepage = "https://github.com/elementary/switchboard-plug-printers";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };

}
