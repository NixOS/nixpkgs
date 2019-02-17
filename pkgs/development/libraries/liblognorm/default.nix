{ stdenv, fetchurl, pkgconfig, libestr, json_c, pcre, fastJson }:

stdenv.mkDerivation rec {
  name = "liblognorm-2.0.6";

  src = fetchurl {
    url = "http://www.liblognorm.com/files/download/${name}.tar.gz";
    sha256 = "1wpn15c617r7lfm1z9d5aggmmi339s6yn4pdz698j0r2bkl5gw6g";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libestr json_c pcre fastJson ];

  configureFlags = [ "--enable-regexp" ];

  meta = with stdenv.lib; {
    homepage = http://www.liblognorm.com/;
    description = "Help to make sense out of syslog data, or, actually, any event data that is present in text form";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
