{ stdenv, fetchurl, pkgconfig, systemd }:

stdenv.mkDerivation rec {
  name = "liblogging-1.0.4";

  src = fetchurl {
    url = "http://download.rsyslog.com/liblogging/${name}.tar.gz";
    sha256 = "075q6zjqpdlmaxhahd1ynr6nasqpyjnzj1zlcvzp3ixxm0m5vsxc";
  };

  buildInputs = [ pkgconfig systemd ];

  meta = {
    description = "Lightweight signal-safe logging library";
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.all;
  };
}
