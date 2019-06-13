{ stdenv, fetchurl, fetchpatch, meson, ninja
, pkgconfig, python, gst-plugins-base, libxml2
, flex, perl, gettext, gobject-introspection
}:

stdenv.mkDerivation rec {
  name = "gstreamer-editing-services-${version}";
  version = "1.14.4";

  meta = with stdenv.lib; {
    description = "Library for creation of audio/video non-linear editors";
    homepage    = "https://gstreamer.freedesktop.org";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer-editing-services/${name}.tar.xz";
    sha256 = "0pxk65jib3mqszjkyvlzklwia4kbdj6j2b6jw1d502b06mdx5lak";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkgconfig gettext gobject-introspection python flex perl ];

  propagatedBuildInputs = [ gst-plugins-base libxml2 ];

  patches = [
    (fetchpatch {
        url = "https://bug794856.bugzilla-attachments.gnome.org/attachment.cgi?id=370413";
        sha256 = "1xcgbs18g6n5p7z7kqj7ffakwmkxq7ijajyvhyl7p3zvqll9dc7x";
    })
    ./fix_pkgconfig_includedir.patch
  ];

  postPatch = ''
    sed -i -r -e 's/p(bad|good) = .*/p\1 = pbase/' tests/check/meson.build
  '';
}
