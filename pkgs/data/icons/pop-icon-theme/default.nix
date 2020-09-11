{ stdenv
, fetchFromGitHub
, meson
, ninja
, gtk3
, breeze-icons
, gnome3
, pantheon
, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "pop-icon-theme";
  version = "2020-03-04";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "icon-theme";
    rev = "11f18cb48455b47b6535018f1968777100471be1";
    sha256 = "1s4pjwv2ynw400gnzgzczlxzw3gxh5s8cxxbi9zpxq4wzjg6jqyv";
  };

  nativeBuildInputs = [
    meson
    ninja
    gtk3
  ];

  propagatedBuildInputs = [
    breeze-icons
    gnome3.adwaita-icon-theme
    pantheon.elementary-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  meta = with stdenv.lib; {
    description = "Icon theme for Pop!_OS with a semi-flat design and raised 3D motifs";
    homepage = "https://github.com/pop-os/icon-theme";
    license = with licenses; [ cc-by-sa-40 gpl3 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
  };
}
