{ stdenv, fetchurl, pkgconfig, glib, libtiff, libjpeg, libpng, libX11
, jasper, libintlOrEmpty, gobjectIntrospection }:

let
  ver_maj = "2.32";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "gdk-pixbuf-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/gdk-pixbuf/${ver_maj}/${name}.tar.xz";
    sha256 = "537655ec3635740e949457bafe61ae44ce0e5642a2529a9ef7ee0bcd5e911b67";
  };

  setupHook = ./setup-hook.sh;

  # !!! We might want to factor out the gdk-pixbuf-xlib subpackage.
  buildInputs = [ libX11 libintlOrEmpty ];

  nativeBuildInputs = [ pkgconfig gobjectIntrospection ];

  propagatedBuildInputs = [ glib libtiff libjpeg libpng jasper ];

  configureFlags = "--with-libjasper --with-x11"
    + stdenv.lib.optionalString (gobjectIntrospection != null) " --enable-introspection=yes"
    ;

  # The tests take an excessive amount of time (> 1.5 hours) and memory (> 6 GB).
  doCheck = false;

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "A library for image loading and manipulation";
    homepage = http://library.gnome.org/devel/gdk-pixbuf/;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.unix;
  };
}
