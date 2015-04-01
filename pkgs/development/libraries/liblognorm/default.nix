{ stdenv, fetchurl, pkgconfig, libestr, json_c, pcre }:

stdenv.mkDerivation rec {
  name = "liblognorm-1.1.1";
  
  src = fetchurl {
    url = "http://www.liblognorm.com/files/download/${name}.tar.gz";
    sha256 = "1wi28n5ahajvl64wfn7jpvnskccd6837i0cyq8w8cvrm362b6pd7";
  };

  buildInputs = [ pkgconfig libestr json_c pcre ];
  
  configureFlags = [ "--enable-regexp" ];

  meta = with stdenv.lib; {
    homepage = http://www.liblognorm.com/;
    description = "help to make sense out of syslog data, or, actually, any event data that is present in text form";
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
