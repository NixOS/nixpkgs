{ stdenv, fetchurl, pkg-config, gobject-introspection, glib, python3, libgudev, libmbim }:

stdenv.mkDerivation rec {
  pname = "libqmi";
  version = "1.26.6";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libqmi/${pname}-${version}.tar.xz";
    sha256 = "1fbwz6534q6n4bgabdx4svbgkf4mdyisjh3y51jjd94p22xn66d7";
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
