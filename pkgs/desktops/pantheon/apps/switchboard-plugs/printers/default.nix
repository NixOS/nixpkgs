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

  patches = [
    # Fix build with latest Vala.
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-printers/commit/5eced5ddda6f229d7265ea0a713f6c1cd181a526.patch";
      sha256 = "lPTNqka6jjvv1JnAqVzVIQBIdDXlCOQ5ASvgZNuEUC8=";
    })
  ];

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
