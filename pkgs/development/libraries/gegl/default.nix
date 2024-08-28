{ lib
, stdenv
, fetchurl
, pkg-config
, vala
, gi-docgen
, gobject-introspection
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
, withLuaJIT ? lib.meta.availableOn stdenv.hostPlatform luajit
}:

stdenv.mkDerivation rec {
  pname = "gegl";
  version = "0.4.48";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  src = fetchurl {
    url = "https://download.gimp.org/pub/gegl/${lib.versions.majorMinor version}/gegl-${version}.tar.xz";
    hash = "sha256-QYwm2UvogF19mPbeDGglyia9dPystsGI2kdTPZ7igkc=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    meson
    ninja
    vala
    gobject-introspection
    gi-docgen
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
    openexr
    suitesparse
  ] ++ lib.optionals stdenv.isDarwin [
    OpenCL
  ] ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ] ++ lib.optionals withLuaJIT [
    luajit
  ];

  # for gegl-4.0.pc
  propagatedBuildInputs = [
    glib
    json-glib
    babl
  ];

  mesonFlags = [
    "-Dmrg=disabled" # not sure what that is
    "-Dsdl2=disabled"
    "-Dpygobject=disabled"
    "-Dlibav=disabled"
    "-Dlibv4l=disabled"
    "-Dlibv4l2=disabled"
    # Disabled due to multiple vulnerabilities, see
    # https://github.com/NixOS/nixpkgs/pull/73586
    "-Djasper=disabled"
  ] ++ lib.optionals (!withLuaJIT) [
    "-Dlua=disabled"
  ];

  postPatch = ''
    chmod +x tests/opencl/opencl_test.sh
    patchShebangs tests/ff-load-save/tests_ff_load_save.sh tests/opencl/opencl_test.sh tools/xml_insert.sh
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
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
