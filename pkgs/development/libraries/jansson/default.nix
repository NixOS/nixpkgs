{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "jansson-2.9";

  src = fetchurl {
    url = "http://www.digip.org/jansson/releases/${name}.tar.gz";
    sha256 = "19fjgfwjfj99rqa3kf96x5rssj88siazggksgrikd6h4r9sd1l0a";
  };

  meta = with stdenv.lib; {
    homepage = http://www.digip.org/jansson/;
    description = "C library for encoding, decoding and manipulating JSON data";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
