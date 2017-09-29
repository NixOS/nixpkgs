{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wireless-regdb-${version}";
  version = "2017.03.07";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/wireless-regdb/${name}.tar.xz";
    sha256 = "1f9mcp78sdd4sci6v32vxfcl1rfjpv205jisz1p93kkfnaisy7ip";
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
    maintainers = with maintainers; [ nckx fpletz ];
  };
}
