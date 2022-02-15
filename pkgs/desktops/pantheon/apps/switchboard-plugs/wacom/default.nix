{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, glib
, granite
, gtk3
, libgee
, libgudev
, libwacom
, switchboard
, xorg
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-wacom";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1n2yfq4s9xpnfqjikchjp4z2nk8cmfz4g0p18cplzh5w1lvz17lm";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/switchboard-plug-wacom/pull/29
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-wacom/commit/2a7dee180d73ffb3521d806efb7028f5a71cb511.patch";
      sha256 = "06ra5c0f14brmj2mmsqscpc4d1114i4qazgnsazzh2hrp04ilnva";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    granite
    gtk3
    libgee
    libgudev
    libwacom
    switchboard
    xorg.libX11
    xorg.libXi
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Switchboard Wacom Plug";
    homepage = "https://github.com/elementary/switchboard-plug-wacom";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
