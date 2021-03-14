{ lib, stdenv, fetchurl, pkg-config, gobject-introspection, glib, python3, libgudev, libmbim }:

stdenv.mkDerivation rec {
  pname = "libqmi";
  version = "1.26.10";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libqmi/${pname}-${version}.tar.xz";
    sha256 = "sha256-fABD8GyHXlzx3jwMlMzH9bBYYry82eT7DV0UJ30dq1k=";
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

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/libqmi/";
    description = "Modem protocol helper library";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
