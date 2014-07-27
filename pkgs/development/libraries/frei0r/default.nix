{ stdenv, fetchurl, autoconf, cairo, opencv, pkgconfig }:

stdenv.mkDerivation rec {
  name = "frei0r-plugins-${version}";
  version = "1.4";

  src = fetchurl {
    url = "https://files.dyne.org/.xsend.php?file=frei0r/releases/${name}.tar.gz";
    sha256 = "0mxyhdp1p1a3ga8170ijygb870zwbww1dgp3kdr1nd4zvsmzqw44";
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
