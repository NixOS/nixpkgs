{ stdenv
, substituteAll
, fetchFromGitHub
, pantheon
, meson
, ninja
, pkgconfig
, vala
, libgee
, granite
, gtk3
, switchboard
, onboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-a11y";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1wh46lrsliii5bbvfc4xnzgnii2v7sqxnbn43ylmyqppfv9mk1wd";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit onboard;
    })
  ];

  passthru = {
    updateScript = pantheon.updateScript {
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
    granite
    gtk3
    libgee
    switchboard
  ];

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder "out"}/lib/switchboard";

  meta = with stdenv.lib; {
    description = "Switchboard Universal Access Plug";
    homepage = https://github.com/elementary/switchboard-plug-a11y;
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
