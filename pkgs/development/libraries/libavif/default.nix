{ lib, stdenv
, fetchFromGitHub
, libaom
, cmake
, pkg-config
, zlib
, libpng
, libjpeg
, dav1d
, libyuv
, gdk-pixbuf
, makeWrapper
}:

let
  gdkPixbufModuleDir = "${placeholder "out"}/${gdk-pixbuf.moduleDir}";
  gdkPixbufModuleFile = "${placeholder "out"}/${gdk-pixbuf.binaryDir}/avif-loaders.cache";
in

stdenv.mkDerivation rec {
  pname = "libavif";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "AOMediaCodec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yNJiMTWgOKR1c2pxTkLY/uPWGIY4xgH+Ee0r15oroDU=";
  };

  # reco: encode libaom slowest but best, decode dav1d fastest

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DAVIF_CODEC_AOM=ON" # best encoder (slow but small)
    "-DAVIF_CODEC_DAV1D=ON" # best decoder (fast)
    "-DAVIF_CODEC_AOM_DECODE=OFF"
    "-DAVIF_BUILD_APPS=ON"
    "-DAVIF_BUILD_GDK_PIXBUF=ON"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    gdk-pixbuf
    makeWrapper
  ];

  buildInputs = [
    gdk-pixbuf
    zlib
    libpng
    libjpeg
  ];

  propagatedBuildInputs = [
    dav1d
    libaom
    libyuv
  ];

  postPatch = ''
    substituteInPlace contrib/gdk-pixbuf/avif.thumbnailer.in \
      --replace '@CMAKE_INSTALL_FULL_BINDIR@/gdk-pixbuf-thumbnailer' "$out/libexec/gdk-pixbuf-thumbnailer-avif"
  '';

  env.PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_MODULEDIR = gdkPixbufModuleDir;

  postInstall = ''
    GDK_PIXBUF_MODULEDIR=${gdkPixbufModuleDir} \
    GDK_PIXBUF_MODULE_FILE=${gdkPixbufModuleFile} \
    gdk-pixbuf-query-loaders --update-cache

  ''
  # Cross-compiled gdk-pixbuf doesn't support thumbnailers
  + lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    mkdir -p "$out/bin"
    makeWrapper ${gdk-pixbuf}/bin/gdk-pixbuf-thumbnailer "$out/libexec/gdk-pixbuf-thumbnailer-avif" \
      --set GDK_PIXBUF_MODULE_FILE ${gdkPixbufModuleFile}
  '';

  meta = with lib; {
    description  = "C implementation of the AV1 Image File Format";
    longDescription = ''
      Libavif aims to be a friendly, portable C implementation of the
      AV1 Image File Format. It is a work-in-progress, but can already
      encode and decode all AOM supported YUV formats and bit depths
      (with alpha). It also features an encoder and a decoder
      (avifenc/avifdec).
    '';
    homepage    = "https://github.com/AOMediaCodec/libavif";
    changelog   = "https://github.com/AOMediaCodec/libavif/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ mkg20001 ];
    platforms   = platforms.all;
    license     = licenses.bsd2;
  };
}
