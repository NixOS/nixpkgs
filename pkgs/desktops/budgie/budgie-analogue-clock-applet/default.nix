{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vala
, budgie-desktop
, gtk3
, libpeas
}:

stdenv.mkDerivation rec {
  pname = "budgie-analogue-clock-applet";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "samlane-ma";
    repo = "analogue-clock-applet";
    rev = "v${version}";
    hash = "sha256-yId5bbdmELinBmZ5eISa5hQSYkeZCkix2FJ287GdcCs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    budgie-desktop
    gtk3
    libpeas
  ];

  meta = with lib; {
    description = "Analogue Clock Applet for the Budgie desktop";
    homepage = "https://github.com/samlane-ma/analogue-clock-applet";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.federicoschonborn ];
    platforms = platforms.linux;
  };
}
