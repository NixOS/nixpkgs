{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.9.7";
  name = "libcli-${version}";

  src = fetchurl {
    url = "https://github.com/dparrish/libcli/archive/v${version}.tar.gz";
    sha256 = "0v4867jbach5zd1nq0sspq5q95vvbpnljzm2yf64k8a4w2vadpbx";
  };

  enableParallelBuilding = true;

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Emulate a Cisco-style telnet command-line interface";
    homepage = http://sites.dparrish.com/libcli;
    license = with licenses; lgpl21Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
