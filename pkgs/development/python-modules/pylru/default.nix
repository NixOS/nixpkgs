{ lib, buildPythonPackage, fetchurl }:

buildPythonPackage rec {
  name = "pylru-${version}";
  version = "1.0.9";

  src = fetchurl {
    url = "mirror://pypi/p/pylru/${name}.tar.gz";
    sha256 = "0b0pq0l7xv83dfsajsc49jcxzc99kb9jfx1a1dlx22hzcy962dvi";
  };

  meta = with lib; {
    homepage = https://github.com/jlhutch/pylru;
    description = "A least recently used (LRU) cache implementation";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
  };
}
