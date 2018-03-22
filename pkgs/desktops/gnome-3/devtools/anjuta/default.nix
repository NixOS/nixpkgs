{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, flex, bison, libxml2, intltool,
  itstool, python3, ncurses, makeWrapper }:

stdenv.mkDerivation rec {
  name = "anjuta-${version}";
  version = "3.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/anjuta/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "fb895464c1a3c915bb2bb3ea5d236fd17202caa7205f6792f70a75affc343d70";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "anjuta"; attrPath = "gnome3.anjuta"; };
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkgconfig intltool itstool python3 makeWrapper
    # Required by python3
    ncurses
  ];
  buildInputs = [
    flex bison gtk3 libxml2 gnome3.gjs gnome3.gdl
    gnome3.libgda gnome3.gtksourceview
    gnome3.gsettings-desktop-schemas
  ];

  preFixup = ''
    wrapProgram $out/bin/anjuta \
      --prefix XDG_DATA_DIRS : \
        "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Software development studio";
    homepage = http://anjuta.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
