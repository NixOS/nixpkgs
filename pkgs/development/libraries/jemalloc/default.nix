{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jemalloc-4.1.1";

  src = fetchurl {
    url = "http://www.canonware.com/download/jemalloc/${name}.tar.bz2";
    sha256 = "1bmdr51wxiir595k2r6z9a7rcgm42kkgnr586xir7vdcndr3pwf8";
  };

  meta = with stdenv.lib; {
    homepage = http://www.canonware.com/jemalloc/index.html;
    description = "General purpose malloc(3) implementation";
    longDescription = ''
      malloc(3)-compatible memory allocator that emphasizes fragmentation
      avoidance and scalable concurrency support.
    '';
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
