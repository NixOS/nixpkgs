{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "jansson-2.8";

  src = fetchurl {
    url = "http://www.digip.org/jansson/releases/${name}.tar.gz";
    sha256 = "0v7v82mv7x44rpcxmrpnmb8hqimx67qwsp2cz9mv3y0f37iykwnf";
  };

  meta = with stdenv.lib; {
    homepage = "http://www.digip.org/jansson/";
    description = "C library for encoding, decoding and manipulating JSON data";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
