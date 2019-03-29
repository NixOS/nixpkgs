{ stdenv, fetchFromGitHub, pantheon, meson, ninja, pkgconfig
, vala, libgee, granite, gtk3, pulseaudio, libcanberra, libcanberra-gtk3
, switchboard, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-sound";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0dvxmjziifffa2rm7h43ca5grhlcpih3rgik50mz808mqfxr4l1q";
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
    libcanberra
    libcanberra-gtk3
    libgee
    pulseaudio
    switchboard
  ];

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "lib/switchboard";

  meta = with stdenv.lib; {
    description = "Switchboard Sound Plug";
    homepage = https://github.com/elementary/switchboard-plug-sound;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
