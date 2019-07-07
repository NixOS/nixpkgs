{ stdenv, fetchurl, pkgconfig, glib, python3, libgudev, libmbim }:

stdenv.mkDerivation rec {
  pname = "libqmi";
  version = "1.22.4";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libqmi/${pname}-${version}.tar.xz";
    sha256 = "1wgrrb9vb3myl8xgck8ik86876ycbg8crylybs3ssi21vrxqwnsc";
  };

  outputs = [ "out" "dev" "devdoc" ];

  configureFlags = [
    "--with-udev-base-dir=${placeholder ''out''}/lib/udev"
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
    homepage = https://www.freedesktop.org/wiki/Software/libqmi/;
    description = "Modem protocol helper library";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
