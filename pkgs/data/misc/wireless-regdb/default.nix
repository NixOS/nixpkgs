{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "wireless-regdb";
  version = "2020.04.29";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0yicda474ygahv8da18h1p4yf42s6x2f208mlwcw4xsrxld07zc9";
  };

  dontBuild = true;

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  meta = with stdenv.lib; {
    description = "Wireless regulatory database for CRDA";
    homepage = "http://wireless.kernel.org/en/developers/Regulatory/";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
