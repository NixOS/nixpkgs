{ stdenv, fetchurl, python2, pkgconfig, libgnome, GConf, glib, gtk, gnome_vfs }:

with stdenv.lib;

let
  inherit (python2.pkgs) python pygobject2 pygtk dbus-python;
in stdenv.mkDerivation rec {
  version = "2.28";
  name = "gnome-python-${version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-python/${version}/${name}.tar.bz2";
    sha256 = "759ce9344cbf89cf7f8449d945822a0c9f317a494f56787782a901e4119b96d8";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python glib gtk GConf libgnome gnome_vfs ];
  propagatedBuildInputs = [ pygobject2 pygtk dbus-python ];

  # gnome-python expects that .pth file is already installed by PyGTK in the
  # same directory. This is not the case for Nix.
  postInstall = ''
    echo "gtk-2.0" > $out/${python2.sitePackages}/${name}.pth
  '';

  meta = with stdenv.lib; {
    homepage = "http://pygtk.org/";
    description = "Python wrapper for GNOME libraries";
    platforms = platforms.linux;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ qknight ];
  };
}
