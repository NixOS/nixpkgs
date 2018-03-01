{ stdenv, intltool, fetchurl, libgtop, pkgconfig, gtk3, glib
, bash, makeWrapper, itstool, gnome3, file }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extensions-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell-extensions/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "aefda4d810ef5ceb9402e2d620f4bdc1dc40c9cc4f6a51749840f7dd08628ab6";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-shell-extensions"; attrPath = "gnome3.gnome-shell-extensions"; };
  };

  doCheck = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 glib libgtop intltool itstool
                  makeWrapper file ];

  configureFlags = [ "--enable-extensions=all" ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomeShell/Extensions;
    description = "Modify and extend GNOME Shell functionality and behavior";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
