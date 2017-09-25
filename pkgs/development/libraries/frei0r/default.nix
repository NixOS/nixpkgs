{ stdenv, fetchurl, autoconf, cairo, opencv, pkgconfig }:

stdenv.mkDerivation rec {
  name = "frei0r-plugins-${version}";
  version = "1.6.1";

  src = fetchurl {
    url = "https://files.dyne.org/frei0r/releases/${name}.tar.gz";
    sha256 = "0pji26fpd0dqrx1akyhqi6729s394irl73dacnyxk58ijqq4dhp0";
  };

  buildInputs = [ autoconf cairo opencv pkgconfig ];

  meta = with stdenv.lib; {
    homepage = http://frei0r.dyne.org;
    description = "Minimalist, cross-platform, shared video plugins";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;

  };
}
