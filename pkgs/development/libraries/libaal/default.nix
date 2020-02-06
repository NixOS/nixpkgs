{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.0.6";
  pname = "libaal";

  src = fetchurl {
    url = "mirror://sourceforge/reiser4/${pname}-${version}.tar.gz";
    sha256 = "176f2sns6iyxv3h9zyirdinjwi05gdak48zqarhib2s38rvm98di";
  };

  patches = [ ./libaal-1.0.6-glibc-2.26.patch ];

  preInstall = ''
    substituteInPlace Makefile --replace ./run-ldconfig true
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.namesys.com/;
    description = "Support library for Reiser4";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
