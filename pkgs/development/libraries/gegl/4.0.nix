{ stdenv
, fetchurl
, fetchpatch
, pkgconfig
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
}:

stdenv.mkDerivation rec {
  pname = "gegl";
  version = "0.4.18";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  src = fetchurl {
    url = "https://download.gimp.org/pub/gegl/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0r6akqnrkvxizyhyi8sv40mxm7j4bcwjb6mqjpxy0zzbbfsdyin9";
  };

  patches = [
    # Fix arch detection.
    # https://gitlab.gnome.org/GNOME/gegl/merge_requests/53
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gegl/commit/6bcf95fd0f32cf5e8b1ddbe17b14d9ad049bded8.patch";
      sha256 = "0aqdr3y5mr47wq44jnhp97188bvpjlf56zrlmn8aazdf07r2apma";
    })

    # Fix Darwin build.
    # https://gitlab.gnome.org/GNOME/gegl/merge_requests/54
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gegl/commit/2bc06bfedee4fb25f6a966c8235b75292e24e55f.patch";
      sha256 = "1psls61wsrdq5pzpvj22mrm46lpzrw3wkx6li7dv6fyb65wz2n4d";
    })

    # Fix test timeout. Downstream debian patch.
    (fetchpatch {
      url = "https://salsa.debian.org/gnome-team/gegl/raw/9b7520b38d87cd8ad4b39bf0b8c62d011da25169/debian/patches/increase_test_timeout.patch";
      sha256 = "1prc1h1aipjd9db0i1j7nzga4zvk3vl8qsjpz1jzv1wwvz02isly";
    })

    # Remove gegl:simple / backend-file test that times out frequently
    ./patches/no-simple-backend-file-test.patch
  ];

  nativeBuildInputs = [
    pkgconfig
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
    bzip2
    libraw
    libwebp
    gexiv2
    luajit
    openexr
  ] ++ stdenv.lib.optional stdenv.isDarwin OpenCL;

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
    "-Dumfpack=disabled"
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

  meta = with stdenv.lib; {
    description = "Graph-based image processing framework";
    homepage = http://www.gegl.org;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
