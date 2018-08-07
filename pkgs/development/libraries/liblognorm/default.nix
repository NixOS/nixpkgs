{ stdenv, fetchurl, pkgconfig, libestr, json_c, pcre, fastJson }:

stdenv.mkDerivation rec {
  name = "liblognorm-2.0.5";

  src = fetchurl {
    url = "http://www.liblognorm.com/files/download/${name}.tar.gz";
    sha256 = "145i1lrl2n145189i7l2a62yazjg9rkyma5jic41y0r17fl1s5f8";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libestr json_c pcre fastJson ];

  configureFlags = [ "--enable-regexp" ];

  meta = with stdenv.lib; {
    homepage = http://www.liblognorm.com/;
    description = "Help to make sense out of syslog data, or, actually, any event data that is present in text form";
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
