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
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1vpw06ldhy26xs5vp2gx5s8wbl42dznycp3jsnm5qp8iid8wl6l6";
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
