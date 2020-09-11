{ stdenv, fetchurl, pkg-config, gobject-introspection, glib, python3, libgudev, libmbim }:

stdenv.mkDerivation rec {
  pname = "libqmi";
  version = "1.26.2";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libqmi/${pname}-${version}.tar.xz";
    sha256 = "00vvvfq74awg6mk0si1cdv79f6z6wqx11h47nl78a1h7zsr6fd0k";
  };

  outputs = [ "out" "dev" "devdoc" ];

  configureFlags = [
    "--with-udev-base-dir=${placeholder "out"}/lib/udev"
    "--enable-introspection"
  ];

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    python3
  ];

  buildInputs = [
    glib
    libgudev
    libmbim
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/libqmi/";
    description = "Modem protocol helper library";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
