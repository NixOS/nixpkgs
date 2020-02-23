{ stdenv, fetchurl, pkgconfig, glib, python3, libgudev, libmbim }:

stdenv.mkDerivation rec {
  pname = "libqmi";
  version = "1.24.4";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libqmi/${pname}-${version}.tar.xz";
    sha256 = "12licfsszr6qxpg9b2b04qm2glk8d42fcy32zr8jzwrgr7gbl5h3";
  };

  outputs = [ "out" "dev" "devdoc" ];

  configureFlags = [
    "--with-udev-base-dir=${placeholder "out"}/lib/udev"
  ];

  nativeBuildInputs = [
    pkgconfig
    python3
  ];

  buildInputs = [
    glib
    libgudev
    libmbim
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/libqmi/";
    description = "Modem protocol helper library";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
