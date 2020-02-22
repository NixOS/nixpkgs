{ stdenv, fetchurl, pkgconfig, glib, python3, libgudev, libmbim }:

stdenv.mkDerivation rec {
  pname = "libqmi";
  version = "1.24.2";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libqmi/${pname}-${version}.tar.xz";
    sha256 = "10mjfmiznaxvfk0f9wr18kyxz3mpdrvnh0qw9g8c1nv0z5vf9r2a";
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
    homepage = https://www.freedesktop.org/wiki/Software/libqmi/;
    description = "Modem protocol helper library";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
