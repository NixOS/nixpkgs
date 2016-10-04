{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.0.6";
  name = "libaal-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/reiser4/${name}.tar.gz";
    sha256 = "176f2sns6iyxv3h9zyirdinjwi05gdak48zqarhib2s38rvm98di";
  };

  preInstall = ''
    substituteInPlace Makefile --replace ./run-ldconfig true
  '';

  meta = {
    homepage = http://www.namesys.com/;
    description = "Support library for Reiser4";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
