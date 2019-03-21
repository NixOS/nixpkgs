{ fetchurl, stdenv, pkgconfig, gtk2 }:

stdenv.mkDerivation rec {
  name = "gtkimageview-1.6.4";

  src = fetchurl {
    url = "http://trac.bjourne.webfactional.com/chrome/common/releases/${name}.tar.gz";
    sha256 = "1if3yh5z6nkv5wnkk0qyy9pkk03vn5rqbfk23q87kj39pqscgr37";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 ];

  preConfigure = ''
    sed '/DEPRECATED_FLAGS/d' -i configure
    sed 's/-Wall -Werror//' -i configure
  '';

  doCheck = true;

  meta = {
    homepage = "https://wiki.gnome.org/Projects/GTK%2B/GtkImageView";

    description = "Image viewer widget for GTK+";

    longDescription =
      '' GtkImageView is a simple image viewer widget for GTK+.  Similar to
         the image viewer panes in gThumb or Eye of Gnome.  It makes writing
         image viewing and editing applications easy.  Among its features
         are: mouse and keyboard zooming; scrolling and dragging; adjustable
         interpolation; GIF animation support.
       '';

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.linux;
  };
}
