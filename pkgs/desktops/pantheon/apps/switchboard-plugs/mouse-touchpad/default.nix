{ stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, pkgconfig
, vala
, libgee
, granite
, gtk3
, switchboard
, elementary-settings-daemon
, glib
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-mouse-touchpad";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0jfykvdpjlymnks8mhlv9957ybq7srqqq23isjvh0jvc2r3cd7sq";
  };

  passthru = {
    updateScript = nix-update-script {
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
    glib
    granite
    gtk3
    libgee
    elementary-settings-daemon
    switchboard
  ];

  meta = with stdenv.lib; {
    description = "Switchboard Mouse & Touchpad Plug";
    homepage = "https://github.com/elementary/switchboard-plug-mouse-touchpad";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
