{ lib, stdenv, fetchurl, pkg-config, gnome, gtk3, gjs, flex, bison, libxml2, intltool,
  gdl, libgda, gtksourceview, gsettings-desktop-schemas,
  itstool, python3, ncurses, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "anjuta";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/anjuta/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "13ql7axw6zz387s7pa1m7wmh7qps3x7fk53h9832vq1yxlq33aa2";
  };

  passthru = {
    updateScript = gnome.updateScript { packageName = "anjuta"; attrPath = "gnome.anjuta"; };
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config intltool itstool python3 makeWrapper
    # Required by python3
    ncurses
  ];
  buildInputs = [
    flex bison gtk3 libxml2 gjs gdl
    libgda gtksourceview
    gsettings-desktop-schemas
  ];

  preFixup = ''
    wrapProgram $out/bin/anjuta \
      --prefix XDG_DATA_DIRS : \
        "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with lib; {
    description = "Software development studio";
    homepage = "https://gitlab.gnome.org/Archive/anjuta/";
    license = licenses.gpl2;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
