{ fetchurl, stdenv, pkgconfig, gtk }:

stdenv.mkDerivation rec {
  name = "gtkimageview-1.6.4";

  src = fetchurl {
    url = "http://trac.bjourne.webfactional.com/chrome/common/releases/${name}.tar.gz";
    sha256 = "1if3yh5z6nkv5wnkk0qyy9pkk03vn5rqbfk23q87kj39pqscgr37";
  };

  buildInputs = [ pkgconfig gtk ];

  doCheck = true;

  meta = {
    homepage = http://trac.bjourne.webfactional.com/;

    description = "The GtkImageView image viewer widget for GTK+";

    longDescription =
      '' GtkImageView is a simple image viewer widget for GTK+.  Similar to
         the image viewer panes in gThumb or Eye of Gnome.  It makes writing
         image viewing and editing applications easy.  Among its features
         are: mouse and keyboard zooming; scrolling and dragging; adjustable
         interpolation; GIF animation support.
       '';

    license = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
