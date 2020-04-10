{ stdenv
, fetchFromGitHub 
, pantheon
, pkgconfig
, meson
, python3
, ninja
, vala
, gtk3
, granite
, wingpanel
, evolution-data-server
, libical
, libgee
, libxml2
, libsoup
, elementary-calendar
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-datetime";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0a0pqrpmrdd5pch30lizr9righlc7165z7krmnaxrzd0fvfkbr2h";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkgconfig
    python3
    vala
  ];

  buildInputs = [
    evolution-data-server
    granite
    gtk3
    libgee
    libical
    libsoup
    wingpanel
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Date & Time Indicator for Wingpanel";
    homepage = https://github.com/elementary/wingpanel-indicator-datetime;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
