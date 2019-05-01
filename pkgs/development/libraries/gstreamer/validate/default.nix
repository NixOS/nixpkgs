{ stdenv, fetchurl, fetchpatch, pkgconfig, gstreamer, gst-plugins-base
, python, gobject-introspection, json-glib
}:

stdenv.mkDerivation rec {
  name = "gst-validate-${version}";
  version = "1.16.0";

  meta = {
    description = "Integration testing infrastructure for the GStreamer framework";
    homepage = https://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-validate/${name}.tar.xz";
    sha256 = "1jfnd0g9hmdbqfxsx96yc9vpf1w6m33hqwrr6lj4i83kl54awcck";
  };

  patches = [
    # Fixes a duplicate symbol compilation error on Darwin.
    # TODO Remove when https://gitlab.freedesktop.org/gstreamer/gst-devtools/commit/22e179cbc1acf8e4bcbc8173c833ea5f086fa28c is available in nixpkgs, likely for 1.18.
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/gstreamer/gst-devtools/commit/751a6d756c0f7c3a721a235ced74fec17f038185.patch";
      sha256 = "05pzjn63pcsf3y153r7azy8dbr0cmn10d10r11cdprgw2bv5hlha";
      stripLen = 1; # gst-validate is a subdir of the `gst-devtools` git repo
    })
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig gobject-introspection
  ];

  buildInputs = [
    python json-glib
  ];

  propagatedBuildInputs = [ gstreamer gst-plugins-base ];

  enableParallelBuilding = true;

  mesonFlags = [
    # Enables all features, so that we know when new dependencies are necessary.
    "-Dauto_features=enabled"
  ];
}
