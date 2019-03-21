{ stdenv, fetchFromGitHub, pantheon, meson, ninja, pkgconfig, substituteAll, vala
, libgee, granite, gtk3, networkmanager, networkmanagerapplet, switchboard, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-network";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "12lvcc15jngzsa40fjhxa6kccs58h5qq4lqrc7lcx5przmfaik8k";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    networkmanager
    networkmanagerapplet
    switchboard
  ];

  patches = [
    (substituteAll {
      src = ./nma.patch;
      networkmanagerapplet = "${networkmanagerapplet}";
    })
  ];


  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "lib/switchboard";

  meta = with stdenv.lib; {
    description = "Switchboard Networking Plug";
    homepage = https://github.com/elementary/switchboard-plug-network;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
