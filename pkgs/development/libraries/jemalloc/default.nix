{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jemalloc-4.0.0";

  src = fetchurl {
    url = "http://www.canonware.com/download/jemalloc/${name}.tar.bz2";
    sha256 = "1wiydkp8a4adwsgfsd688hpv2z7hjv5manhckchk96v6qdsbqk91";
  };

  meta = with stdenv.lib; {
    homepage = http://www.canonware.com/jemalloc/index.html;
    description = "a general purpose malloc(3) implementation that emphasizes fragmentation avoidance and scalable concurrency support";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
