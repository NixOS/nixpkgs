{ stdenv, fetchurl, pkgconfig, intltool, gtk2, withGtk3 ? false, gtk3 ? null }:

assert withGtk3 -> (gtk3 != null);

stdenv.mkDerivation rec {
  p_name  = "gtk-xfce-engine";
  ver_maj = "3.2";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1va71f3gpl8gikfkmqsd5ikgp7qj8b64jii2l98g1ylnv8xrqp47";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool gtk2 ] ++ stdenv.lib.optional withGtk3 gtk3;

  # `glib-mkenums' is unhappy that some source files are not valid UTF-8
  postPatch = ''find . -type f -name '*.[ch]' -exec sed -r -i 's/\xD6/O/g' {} +'';

  configureFlags = stdenv.lib.optional withGtk3 "--enable-gtk3";

  meta = {
    homepage = https://www.xfce.org/;
    description = "GTK+ theme engine for Xfce";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
