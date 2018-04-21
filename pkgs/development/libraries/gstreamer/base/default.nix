{ stdenv, fetchurl, fetchpatch, pkgconfig, meson
, ninja, gettext, gobjectIntrospection, python
, gstreamer, orc, alsaLib, libXv, pango, libtheora
, wayland, cdparanoia, libvisual, libintl
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-1.14.0";

  meta = {
    description = "Base plugins and helper libraries";
    homepage = https://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-base/${name}.tar.xz";
    sha256 = "0h39bcp7fcd9kgb189lxr8l0hm0almvzpzgpdh1jpq2nzxh4d43y";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig python meson ninja gettext gobjectIntrospection
  ];

  buildInputs = [
    orc libXv pango libtheora cdparanoia libintl wayland
  ]
  ++ stdenv.lib.optional stdenv.isLinux alsaLib
  ++ stdenv.lib.optional (!stdenv.isDarwin) libvisual;

  propagatedBuildInputs = [ gstreamer ];

  preConfigure = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  patches = [
    (fetchpatch {
        url = "https://bug794856.bugzilla-attachments.gnome.org/attachment.cgi?id=370414";
        sha256 = "07x43xis0sr0hfchf36ap0cibx0lkfpqyszb3r3w9dzz301fk04z";
    })
    ./fix_pkgconfig_includedir.patch
  ];
}
