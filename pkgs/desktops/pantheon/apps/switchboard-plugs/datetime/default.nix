{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, meson
, ninja
, substituteAll
, pkg-config
, vala
, libgee
, granite
, gtk3
, libxml2
, switchboard
, tzdata
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-datetime";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "10rqhxsqbl1xnz5n84d7m39c3vb71k153989xvyc55djia1wjx96";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      tzdata = tzdata;
    })
    # Upstream code not respecting our localedir
    # https://github.com/elementary/switchboard-plug-datetime/pull/100
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-datetime/commit/a90639ed4f185f50d4ae448cd9503203dc24b3f4.patch";
      sha256 = "0dz0s02ccnds62dqil44k652pc5icka2rfhcx0a5bj1wi5sifnp7";
    })
  ];

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Switchboard Date & Time Plug";
    homepage = "https://github.com/elementary/switchboard-plug-datetime";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
