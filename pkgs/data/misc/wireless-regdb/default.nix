{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wireless-regdb-${version}";
  version = "2017.12.23";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/wireless-regdb/${name}.tar.xz";
    sha256 = "1faa394frq0126h2z28kp4dwknx6zqm5nar4552g7rwqvl2yclqf";
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
