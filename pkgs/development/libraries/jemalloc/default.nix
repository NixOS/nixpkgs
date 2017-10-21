{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jemalloc-${version}";
  version = "4.5.0";

  src = fetchurl {
    url = "https://github.com/jemalloc/jemalloc/releases/download/${version}/${name}.tar.bz2";
    sha256 = "9409d85664b4f135b77518b0b118c549009dc10f6cba14557d170476611f6780";
  };

  # By default, jemalloc puts a je_ prefix onto all its symbols on OSX, which
  # then stops downstream builds (mariadb in particular) from detecting it. This
  # option should remove the prefix and give us a working jemalloc.
  configureFlags = stdenv.lib.optional stdenv.isDarwin "--with-jemalloc-prefix=";

  doCheck = true;


  meta = with stdenv.lib; {
    homepage = http://jemalloc.net;
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
