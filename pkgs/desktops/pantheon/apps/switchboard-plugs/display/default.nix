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
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-display";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1racp0mxiaix9afx25ryskdcyi335fz8yh8nwgdxbqbm6jpyq4zs";
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
    libgee
    switchboard
  ];

  meta = with stdenv.lib; {
    description = "Switchboard Displays Plug";
    homepage = "https://github.com/elementary/switchboard-plug-display";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
