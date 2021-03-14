{ lib, stdenv
, fetchurl
, fetchpatch
, pkg-config
, vala
, gobject-introspection
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
, glib
, babl
, libpng
, cairo
, libjpeg
, librsvg
, lensfun
, libspiro
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
  version = "0.4.26";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  src = fetchurl {
    url = "https://download.gimp.org/pub/gegl/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-DzceLtK5IWL+/T3edD5kjKCKahsrBQBIZ/vdx+IR5CQ=";
  };

  patches = [
    # fix build with darwin: https://github.com/NixOS/nixpkgs/issues/99108
    # https://gitlab.gnome.org/GNOME/gegl/-/merge_requests/83
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gegl/-/merge_requests/83.patch";
      sha256 = "sha256-CSBYbJ2xnEN23xrla1qqr244jxOR5vNK8ljBSXdg4yE=";
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
    docbook_xsl
    docbook_xml_dtd_43
  ];

  buildInputs = [
    libpng
    cairo
    libjpeg
    librsvg
    lensfun
    libspiro
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
  ] ++ lib.optional stdenv.isDarwin OpenCL;

  # for gegl-4.0.pc
  propagatedBuildInputs = [
    glib
    json-glib
    babl
  ];

  mesonFlags = [
    "-Ddocs=true"
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

  # TODO: Fix missing math symbols in gegl seamless clone.
  # It only appears when we use packaged poly2tri-c instead of vendored one.
  NIX_CFLAGS_COMPILE = "-lm";

  postPatch = ''
    chmod +x tests/opencl/opencl_test.sh tests/buffer/buffer-tests-run.sh
    patchShebangs tests/ff-load-save/tests_ff_load_save.sh tests/opencl/opencl_test.sh tests/buffer/buffer-tests-run.sh tools/xml_insert.sh
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
