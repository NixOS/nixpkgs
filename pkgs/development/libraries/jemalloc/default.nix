{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jemalloc-4.0.2";

  src = fetchurl {
    url = "http://www.canonware.com/download/jemalloc/${name}.tar.bz2";
    sha256 = "04a6iw9wiwiknd7v3l3i7vpmc5nvv52islnb1hz9idmdk259r2hd";
  };

  meta = with stdenv.lib; {
    homepage = http://www.canonware.com/jemalloc/index.html;
    description = "a general purpose malloc(3) implementation that emphasizes fragmentation avoidance and scalable concurrency support";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
