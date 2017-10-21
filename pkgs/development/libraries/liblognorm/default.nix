{ stdenv, fetchurl, pkgconfig, libestr, json_c, pcre }:

stdenv.mkDerivation rec {
  name = "liblognorm-1.1.2";
  
  src = fetchurl {
    url = "http://www.liblognorm.com/files/download/${name}.tar.gz";
    sha256 = "0v2k5awr6vsbp36gybrys3zfkl675sywhsh4lnm7f21inlpi2nlk";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libestr json_c pcre ];
  
  configureFlags = [ "--enable-regexp" ];

  meta = with stdenv.lib; {
    homepage = http://www.liblognorm.com/;
    description = "Help to make sense out of syslog data, or, actually, any event data that is present in text form";
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
