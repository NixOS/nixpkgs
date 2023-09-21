{ lib
, stdenv
, fetchurl
, fetchpatch2
, pkg-config
, vala
, gobject-introspection
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, glib
, babl
, libpng
, llvmPackages
, cairo
, libjpeg
, librsvg
, lensfun
, libspiro
, maxflow
, netsurf
, pango
, poly2tri-c
, poppler
, bzip2
, json-glib
, gettext
, meson
, ninja
, libraw
, gexiv2
, libwebp
, luajit
, openexr
, OpenCL
, suitesparse
}:

stdenv.mkDerivation rec {
  pname = "gegl";
  version = "0.4.46";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  src = fetchurl {
    url = "https://download.gimp.org/pub/gegl/${lib.versions.majorMinor version}/gegl-${version}.tar.xz";
    hash = "sha256-0LOySBvId0xfPQpIdhGRAWbRju+COoWfuR54Grex6JI=";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/gegl/-/merge_requests/136
    # Fix missing libm dependency.
    (fetchpatch2 {
      url = "https://gitlab.gnome.org/GNOME/gegl/-/commit/ee970f10f4fe442cbf8a4f5cb94049deab33e786.patch";
      hash = "sha256-0LLKH+Gg+1H83kN7hJGK2u+oLrw7Hxed7R4tTwT3C5s=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    meson
    ninja
    vala
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ];

  buildInputs = [
    libpng
    cairo
    libjpeg
    librsvg
    lensfun
    libspiro
    maxflow
    netsurf.libnsgif
    pango
    poly2tri-c
    poppler
    bzip2
    libraw
    libwebp
    gexiv2
    luajit
    openexr
    suitesparse
  ] ++ lib.optionals stdenv.isDarwin [
    OpenCL
  ] ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  # for gegl-4.0.pc
  propagatedBuildInputs = [
    glib
    json-glib
    babl
  ];

  mesonFlags = [
    "-Dgtk-doc=true"
    "-Dmrg=disabled" # not sure what that is
    "-Dsdl2=disabled"
    "-Dpygobject=disabled"
    "-Dlibav=disabled"
    "-Dlibv4l=disabled"
    "-Dlibv4l2=disabled"
    # Disabled due to multiple vulnerabilities, see
    # https://github.com/NixOS/nixpkgs/pull/73586
    "-Djasper=disabled"
  ];

  postPatch = ''
    chmod +x tests/opencl/opencl_test.sh
    patchShebangs tests/ff-load-save/tests_ff_load_save.sh tests/opencl/opencl_test.sh tools/xml_insert.sh
  '';

  # tests fail to connect to the com.apple.fonts daemon in sandboxed mode
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Graph-based image processing framework";
    homepage = "https://www.gegl.org";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
