{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "openlibm-${version}";
  version = "0.5.5";
  src = fetchurl {
    url = "https://github.com/JuliaLang/openlibm/archive/v${version}.tar.gz";
    sha256 = "1z8cj5q8ca8kmrakwkpjxf8svi81waw0c568cx8v8pv9kvswbp07";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "High quality system independent, portable, open source libm implementation";
    homepage = http://www.openlibm.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
    platforms = stdenv.lib.platforms.all;
  };
}
