{ lib
, stdenv
, fetchFromGitHub
, meson
, sassc
, pkg-config
, glib
, ninja
, python3
, gtk3
, gnome
, gtk-engine-murrine
, humanity-icon-theme
, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "yaru";
  version = "24.04.0";

  src = fetchFromGitHub {
    owner = "ubuntu";
    repo = "yaru";
    rev = version;
    hash = "sha256-KvpA86YL6toVklRPu4hP3j3w+Q0h/n6mZRZgk3HvMfc=";
  };

  nativeBuildInputs = [ meson sassc pkg-config glib ninja python3 ];
  buildInputs = [ gtk3 gnome.gnome-themes-extra ];
  propagatedBuildInputs = [ humanity-icon-theme hicolor-icon-theme ];
  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontDropIconThemeCache = true;

  postPatch = "patchShebangs .";

  meta = with lib; {
    description = "Ubuntu community theme 'yaru' - default Ubuntu theme since 18.10";
    homepage = "https://github.com/ubuntu/yaru";
    license = with licenses; [ cc-by-sa-40 gpl3Plus lgpl21Only lgpl3Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ moni ];
  };
}
