{ lib, stdenv, fetchurl, python2, pkg-config, libgnome, GConf, glib, gtk2, gnome_vfs }:

with lib;

let
  inherit (python2.pkgs) python pygobject2 pygtk dbus-python;
in stdenv.mkDerivation rec {
  pname = "gnome-python";
  version = "2.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-python/${lib.versions.majorMinor version}/gnome-python-${version}.tar.bz2";
    sha256 = "759ce9344cbf89cf7f8449d945822a0c9f317a494f56787782a901e4119b96d8";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ python glib gtk2 GConf libgnome gnome_vfs ];
  propagatedBuildInputs = [ pygobject2 pygtk dbus-python ];

  # gnome-python expects that .pth file is already installed by PyGTK in the
  # same directory. This is not the case for Nix.
  postInstall = ''
    echo "gtk-2.0" > $out/${python2.sitePackages}/gnome-python-${version}.pth
  '';

  meta = with lib; {
    homepage = "http://pygtk.org/";
    description = "Python wrapper for GNOME libraries";
    platforms = platforms.linux;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ qknight ];
  };
}
