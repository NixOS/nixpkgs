{ lib, stdenv, fetchurl, bison, libuuid, curl, libxml2, flex }:

stdenv.mkDerivation rec {
  version = "3.20.6";
  pname = "libdap";

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libuuid curl libxml2 ];

  src = fetchurl {
    url = "https://www.opendap.org/pub/source/${pname}-${version}.tar.gz";
    sha256 = "0jn5bi8k2lq6mmrsw7r1r5aviyf8gb39b2iy20v4kpkj5napzk1m";
  };

  meta = with lib; {
    description = "A C++ SDK which contains an implementation of DAP";
    homepage = "https://www.opendap.org/software/libdap";
    license = licenses.lgpl2;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.linux;
    broken = true;
  };
}
