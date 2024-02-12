{ fetchurl, lib, stdenv, pkg-config, gtk2 }:

stdenv.mkDerivation rec {
  pname = "gtkimageview";
  version = "1.6.4";

  src = fetchurl {
    url = "https://sources.archlinux.org/other/packages/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1wj63af9j9p5i067lpwi9lxvwalamakrmklvl983kvi7s4w1ss2c";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 ];

  preConfigure = ''
    sed '/DEPRECATED_FLAGS/d' -i configure
    sed 's/-Wall -Werror//' -i configure
  '';

  doCheck = true;

  meta = {
    homepage = "https://wiki.gnome.org/Projects/GTK/GtkImageView";

    description = "Image viewer widget for GTK";

    longDescription =
      '' GtkImageView is a simple image viewer widget for GTK.  Similar to
         the image viewer panes in gThumb or Eye of Gnome.  It makes writing
         image viewing and editing applications easy.  Among its features
         are: mouse and keyboard zooming; scrolling and dragging; adjustable
         interpolation; GIF animation support.
       '';

    license = lib.licenses.lgpl2Plus;

    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
