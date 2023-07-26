{ lib
, stdenv
, fetchurl
, pkg-config
, autoreconfHook
, gnome
, gtk3
, gdk-pixbuf
, librsvg
, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "adwaita-icon-theme";
  version = "44.0";

  src = fetchurl {
    url = "mirror://gnome/sources/adwaita-icon-theme/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "SInFYBu/7NJdgLo0IgnQqTbc9pHuVr1uykzeNh8aZkw=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    gtk3
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  propagatedBuildInputs = [
    # For convenience, we can specify adwaita-icon-theme only in packages
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "adwaita-icon-theme";
      attrPath = "gnome.adwaita-icon-theme";
    };
  };

  meta = with lib; {
    platforms = with platforms; linux ++ darwin;
    maintainers = teams.gnome.members;
    license = licenses.cc-by-sa-30;
  };
}
