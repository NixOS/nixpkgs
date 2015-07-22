{ stdenv, fetchurl, fetchpatch, pkgconfig, libiconv, libintlOrEmpty
, zlib, curl, cairo, freetype, fontconfig, lcms, libjpeg, openjpeg
, qt4Support ? false, qt4 ? null, qt5Support ? false, qt5 ? null
, utils ? false, suffix ? "glib"
}:

let # beware: updates often break cups_filters build
  version = "0.32.0"; # even major numbers are stable
  sha256 = "162vfbvbz0frvqyk00ldsbl49h4bj8i8wn0ngfl30xg1lldy6qs9";
in
stdenv.mkDerivation rec {
  name = "poppler-${suffix}-${version}";

  src = fetchurl {
    url = "${meta.homepage}/poppler-${version}.tar.xz";
    inherit sha256;
  };

  patches = [ ./datadir_env.patch ];

  propagatedBuildInputs = with stdenv.lib;
    [ zlib cairo freetype fontconfig libjpeg lcms curl openjpeg ]
    ++ optional qt4Support qt4
    ++ optional qt5Support qt5.base;

  nativeBuildInputs = [ pkgconfig libiconv ] ++ libintlOrEmpty;

  configureFlags =
    [
      "--enable-xpdf-headers"
      "--enable-libcurl"
      "--enable-zlib"
    ]
    ++ stdenv.lib.optional (!utils) "--disable-utils";

  enableParallelBuilding = true;

  meta = {
    homepage = http://poppler.freedesktop.org/;
    description = "A PDF rendering library";

    longDescription = ''
      Poppler is a PDF rendering library based on the xpdf-3.0 code base.
    '';

    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };
}
