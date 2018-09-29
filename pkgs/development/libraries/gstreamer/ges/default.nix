{ stdenv, fetchurl, fetchpatch, meson, ninja
, pkgconfig, python, gst-plugins-base, libxml2
, flex, perl, gettext, gobjectIntrospection
}:

stdenv.mkDerivation rec {
  name = "gstreamer-editing-services-${version}";
  version = "1.14.2";

  meta = with stdenv.lib; {
    description = "Library for creation of audio/video non-linear editors";
    homepage    = "https://gstreamer.freedesktop.org";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer-editing-services/${name}.tar.xz";
    sha256 = "0d0zqvgxp51mmffz5vvscsdzqqw9mjsv6bnk6ivg2dxnkv8q1ch5";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkgconfig gettext gobjectIntrospection python flex perl ];

  propagatedBuildInputs = [ gst-plugins-base libxml2 ];

  patches = [
    (fetchpatch {
        url = "https://bug794856.bugzilla-attachments.gnome.org/attachment.cgi?id=370413";
        sha256 = "1xcgbs18g6n5p7z7kqj7ffakwmkxq7ijajyvhyl7p3zvqll9dc7x";
    })
    ./fix_pkgconfig_includedir.patch
  ];
}
