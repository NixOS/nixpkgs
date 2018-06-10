{ stdenv, fetchurl, pkgconfig, file, intltool, glib, gtk3, libxklavier, makeWrapper, gnome3 }:

stdenv.mkDerivation rec {
  name = "libgnomekbd-${version}";
  version = "3.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnomekbd/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "ea3b418c57c30615f7ee5b6f718def7c9d09ce34637324361150744258968875";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "libgnomekbd"; attrPath = "gnome3.libgnomekbd"; };
  };

  nativeBuildInputs = [ pkgconfig file intltool makeWrapper ];
  buildInputs = [ glib gtk3 libxklavier ];

  preFixup = ''
    wrapProgram $out/bin/gkbd-keyboard-display \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Keyboard management library";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
