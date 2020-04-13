{ stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, pkgconfig
, python3
, gst-plugins-base
, libxml2
, flex
, gettext
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "gstreamer-editing-services";
  version = "1.16.2";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "05hcf3prna8ajjnqd53221gj9syarrrjbgvjcbhicv0c38csc1hf";
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
    python3
    flex
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
