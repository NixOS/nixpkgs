{ stdenv
, fetchFromGitHub
, pantheon
, meson
, ninja
, pkgconfig
, vala
, libgee
, granite
, gtk3
, pulseaudio
, libcanberra
, libcanberra-gtk3
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-sound";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1aa9wgaz34glrrnilnqis3k0bnx2a2ir38j493y4d0klkjkwyn5k";
  };

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
    libcanberra
    libcanberra-gtk3
    libgee
    pulseaudio
    switchboard
  ];

  meta = with stdenv.lib; {
    description = "Switchboard Sound Plug";
    homepage = https://github.com/elementary/switchboard-plug-sound;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
