{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "jansson-2.11";

  src = fetchurl {
    url = "http://www.digip.org/jansson/releases/${name}.tar.gz";
    sha256 = "1x5jllzzqamq6kahx9d9a5mrarm9m3f30vfxvcqpi6p4mcnz91bf";
  };

  meta = with stdenv.lib; {
    homepage = http://www.digip.org/jansson/;
    description = "C library for encoding, decoding and manipulating JSON data";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
