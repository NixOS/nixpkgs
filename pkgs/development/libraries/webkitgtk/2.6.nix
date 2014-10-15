{ stdenv, fetchurl, cmake, bison, gperf, perl, python, ruby
, pkgconfig, gettext, gobjectIntrospection
, gtk2, gtk3, wayland, libwebp, enchant
, libxml2, libsoup, libsecret, libxslt, harfbuzz
, gst-plugins-base
}:

stdenv.mkDerivation rec {
  name = "webkitgtk-2.6.1";

  meta = {
    description = "Web content rendering engine, GTK+ port";
    homepage = "http://webkitgtk.org/";
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "http://webkitgtk.org/releases/${name}.tar.xz";
    sha256 = "0m3ddi3s3998zkfdpcjv738iglh6wx4678vzwwk9rmrdfriacin8";
  };

  patches = [ ./finding-harfbuzz-icu.patch ];

  cmakeFlags = [
    "-DPORT=GTK"
  ];

  nativeBuildInputs = [
    cmake bison gperf perl python ruby
    pkgconfig gettext gobjectIntrospection
  ];

  buildInputs = [
    gtk2 wayland libwebp enchant
    libxml2 libsecret libxslt harfbuzz
    gst-plugins-base
  ];

  propagatedBuildInputs = [
    libsoup gtk3
  ];

  enableParallelBuilding = true;
}
