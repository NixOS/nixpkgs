{ stdenv, fetchFromGitHub, pantheon, substituteAll, meson, ninja, pkgconfig
, vala, libgee, granite, gtk3, switchboard, pciutils, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-about";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "11diwz2aj45yqkxdija8ny0sgm0wl2905gl3799cdl12ss9ffndp";
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
    switchboard
  ];

  patches = [
    (substituteAll {
      src = ./lspci-path.patch;
      inherit pciutils;
    })
    ./remove-update-button.patch
  ];

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder ''out''}/lib/switchboard";

  meta = with stdenv.lib; {
    description = "Switchboard About Plug";
    homepage = https://github.com/elementary/witchboard-plug-about;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };

}
