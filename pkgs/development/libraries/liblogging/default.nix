{ stdenv, fetchurl, pkgconfig
, systemd ? null
}:

stdenv.mkDerivation rec {
  name = "liblogging-1.0.6";

  src = fetchurl {
    url = "http://download.rsyslog.com/liblogging/${name}.tar.gz";
    sha256 = "14xz00mq07qmcgprlj5b2r21ljgpa4sbwmpr6jm2wrf8wms6331k";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ systemd ];

  configureFlags = [
    "--enable-rfc3195"
    "--enable-stdlog"
    (if systemd != null then "--enable-journal" else "--disable-journal")
    "--enable-man-pages"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.liblogging.org/;
    description = "Lightweight signal-safe logging library";
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
