{ stdenv, fetchFromGitHub, pantheon, meson, ninja, pkgconfig
, vala, libgee, granite, gtk3, switchboard, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-display";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1xpgkvcv3bylpaj7c80727vr55vilkgjvnlbw7d5pr56v6mv7n9j";
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
    description = "Switchboard Displays Plug";
    homepage = https://github.com/elementary/switchboard-plug-display;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
