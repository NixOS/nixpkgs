{ stdenv, fetchurl, pkgconfig, glib, python, libgudev, libmbim }:

stdenv.mkDerivation rec {
  name = "libqmi-1.20.0";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libqmi/${name}.tar.xz";
    sha256 = "1d3fca477sdwbv4bsq1cl98qc8sixrzp0gqjcmjj8mlwfk9qqhi1";
  };

  outputs = [ "out" "dev" "devdoc" ];

  preBuild = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib python libgudev libmbim ];

  configureFlags = ["--enable-mbim-qmux" ];

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/libqmi/;
    description = "Modem protocol helper library";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ wkennington ];
  };
}
