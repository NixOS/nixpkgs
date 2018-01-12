{ stdenv, fetchurl, pkgconfig
, systemd ? null
}:

stdenv.mkDerivation rec {
  name = "liblogging-1.0.5";

  src = fetchurl {
    url = "http://download.rsyslog.com/liblogging/${name}.tar.gz";
    sha256 = "02w94j344q0ywlj4mdf9fnzwggdsn3j1yn43sdlsddvr29lw239i";
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
    maintainers = with maintainers; [ wkennington ];
  };
}
