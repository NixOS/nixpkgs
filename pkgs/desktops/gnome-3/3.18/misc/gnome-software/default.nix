{ stdenv, fetchurl, pkgconfig, intltool, gnome3, wrapGAppsHook, packagekit
, appstream-glib, libsoup, polkit, attr, acl, libyaml, isocodes }:

stdenv.mkDerivation rec {
  name = "gnome-software-${version}";
  version = "3.18.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-software/3.18/${name}.tar.xz";
    sha256 = "0ywvjmn0cwr4kv2l6ic80ac7js7hpsp3g127cj7h256iaqgsaxnc";
  };

  nativeBuildInputs = [ pkgconfig intltool wrapGAppsHook ];
  buildInputs = [ gnome3.gtk packagekit appstream-glib libsoup
                  gnome3.gsettings_desktop_schemas gnome3.gnome_desktop
                  polkit attr acl libyaml ];
  propagatedBuildInputs = [ isocodes ];

  postInstall = ''
    mkdir -p $out/share/xml/
    ln -s ${isocodes}/share/xml/iso-codes $out/share/xml/iso-codes
  '';

  meta = with stdenv.lib; {
    homepage = https://www.freedesktop.org/software/PackageKit/;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    description = "GNOME Software lets you install and update applications and system extensions.";
  };
}
