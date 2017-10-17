{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "jansson-2.10";

  src = fetchurl {
    url = "http://www.digip.org/jansson/releases/${name}.tar.gz";
    sha256 = "0iv4rxsnamqm3ldpg7dyhjq0x9cp023nc7ac820jdd3pwb8ml8bq";
  };

  meta = with stdenv.lib; {
    homepage = http://www.digip.org/jansson/;
    description = "C library for encoding, decoding and manipulating JSON data";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
