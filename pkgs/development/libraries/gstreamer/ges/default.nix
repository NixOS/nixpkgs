{ stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, pkgconfig
, python
, gst-plugins-base
, libxml2
, flex
, perl
, gettext
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "gstreamer-editing-services";
  version = "1.16.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "10375z5mc3bwfs07mhmfx943sbp55z8m8ihp9xpcknkdks7qg168";
  };

  patches = [
    ./fix_pkgconfig_includedir.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gettext
    gobject-introspection
    python
    flex
    perl
  ];

  buildInputs = [
    libxml2
  ];

  propagatedBuildInputs = [
    gst-plugins-base
  ];

  mesonFlags = [
    "-Dgtk_doc=disabled"
  ];

  postPatch = ''
    # for some reason, gst-plugins-bad cannot be found
    # fortunately, they are only used by tests, which we do not run
    sed -i -r -e 's/p(bad|good) = .*/p\1 = pbase/' tests/check/meson.build
  '';

  meta = with stdenv.lib; {
    description = "Library for creation of audio/video non-linear editors";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
