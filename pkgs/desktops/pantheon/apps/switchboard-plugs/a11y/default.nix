{ lib, stdenv
, substituteAll
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, pkg-config
, vala
, libgee
, granite
, gtk3
, switchboard
, onboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-a11y";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0dc5jv335j443rg08cb7p8wvmcg36wrf1vlcfg9r20cksdis9v4l";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit onboard;
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
    granite
    gtk3
    libgee
    switchboard
  ];

  meta = with lib; {
    description = "Switchboard Universal Access Plug";
    homepage = "https://github.com/elementary/switchboard-plug-a11y";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
