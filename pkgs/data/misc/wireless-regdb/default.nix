{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wireless-regdb-${version}";
  version = "2018.09.07";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/wireless-regdb/${name}.tar.xz";
    sha256 = "0nnn10pk94qnrdy55pwcr7506bxdsywa88a3shgqxsd3y53q2sx3";
  };

  dontBuild = true;

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = with stdenv.lib; {
    description = "Wireless regulatory database for CRDA";
    homepage = http://wireless.kernel.org/en/developers/Regulatory/;
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
