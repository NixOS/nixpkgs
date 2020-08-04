{ stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, fetchpatch
, substituteAll
, meson
, ninja
, pkgconfig
, vala
, libgee
, granite
, gtk3
, libxml2
, libgnomekbd
, libxklavier
, xorg
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-keyboard";
  version = "2.3.6";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "08zpw7ygrqmwwznvxkf4xbrgwbjkbwc95sw1ikikg3143ql9qclp";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    libgnomekbd
    libxklavier
    switchboard
  ];

  meta = with stdenv.lib; {
    description = "Switchboard Keyboard Plug";
    homepage = "https://github.com/elementary/switchboard-plug-keyboard";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
