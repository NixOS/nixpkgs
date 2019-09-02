{ stdenv, fetchFromGitHub, pantheon, meson, ninja, pkgconfig
, vala, libgee, granite, gtk3, switchboard, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-sharing";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1yi6aga9i18wwn22zwmfbhsk16f92fka837is5r8xghqb7a50hyh";
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

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder ''out''}/lib/switchboard";

  meta = with stdenv.lib; {
    description = "Switchboard Sharing Plug";
    homepage = https://github.com/elementary/switchboard-plug-sharing;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
