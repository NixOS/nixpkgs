{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, gobject-introspection
, lcms2
}:

stdenv.mkDerivation rec {
  pname = "babl";
  version = "0.1.72";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://download.gimp.org/pub/babl/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0hkagjrnza77aasa1kss5hvy37ndm50y6i7hkdn2z8hzgc4i3qb4";
  };

  patches = [
    # Apple linker does not know --version-script flag
    # https://gitlab.gnome.org/GNOME/babl/merge_requests/26
    ./fix-darwin.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gobject-introspection
  ];

  buildInputs = [
    lcms2
  ];

  meta = with stdenv.lib; {
    description = "Image pixel format conversion library";
    homepage = http://gegl.org/babl/;
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
