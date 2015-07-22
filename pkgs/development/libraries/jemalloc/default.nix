{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jemalloc-3.6.0";

  src = fetchurl {
    url = "http://www.canonware.com/download/jemalloc/${name}.tar.bz2";
    sha256 = "1zl4vxxjvhg72bdl53sl0idz9wp18c6yzjdmqcnwm09wvmcj2v71";
  };

  meta = with stdenv.lib; {
    homepage = http://www.canonware.com/jemalloc/index.html;
    description = "a general purpose malloc(3) implementation that emphasizes fragmentation avoidance and scalable concurrency support";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
