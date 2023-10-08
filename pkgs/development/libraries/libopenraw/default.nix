{ stdenv, fetchurl, boost, gdk-pixbuf, glib, libjpeg, libxml2, lib, pkg-config, cargo, rustc }:

stdenv.mkDerivation rec {
  pname = "libopenraw";
  version = "0.3.7";

  src = fetchurl {
    url = "https://libopenraw.freedesktop.org/download/${pname}-${version}.tar.bz2";
    sha256 = "5515b2610361ef34580b6b976635119f6dedb4f0a79d54662fa5fe6186a45ed5";
  };

  nativeBuildInputs = [ pkg-config cargo rustc ];

  buildInputs = [ boost gdk-pixbuf glib libjpeg libxml2 ];

  postPatch = ''
    sed -i configure{,.ac} \
      -e "s,GDK_PIXBUF_DIR=.*,GDK_PIXBUF_DIR=$out/lib/gdk-pixbuf-2.0/2.10.0/loaders,"
  '';

  configureFlags = [ "--disable-maintainer-mode" ];

  meta = with lib; {
    description = "RAW camerafile decoding library";
    homepage = "https://libopenraw.freedesktop.org";
    license = licenses.lgpl3Plus;
    platforms = [ "x86_64-linux" ];
  };
}