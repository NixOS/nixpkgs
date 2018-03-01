{ stdenv, fetchurl, pkgconfig, intltool, glib, gobjectIntrospection
  # just for passthru
, gnome3, gtk3, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  name = "gsettings-desktop-schemas-${version}";
  version = "3.24.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gsettings-desktop-schemas/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "76a3fa309f9de6074d66848987214f0b128124ba7184c958c15ac78a8ac7eea7";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gsettings-desktop-schemas"; };
  };

  preInstall = ''
    mkdir -p $out/share/gsettings-schemas/${name}/glib-2.0/schemas
    cat - > $out/share/gsettings-schemas/${name}/glib-2.0/schemas/remove-backgrounds.gschema.override <<- EOF
      [org.gnome.desktop.background]
      picture-uri='''

      [org.gnome.desktop.screensaver]
      picture-uri='''
    EOF
  '';

  buildInputs = [ glib gobjectIntrospection ];

  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
  };
}
