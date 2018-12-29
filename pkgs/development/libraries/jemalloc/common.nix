{ version, sha256 }:
{ stdenv, fetchurl
# By default, jemalloc puts a je_ prefix onto all its symbols on OSX, which
# then stops downstream builds (mariadb in particular) from detecting it. This
# option should remove the prefix and give us a working jemalloc.
# Causes segfaults with some software (ex. rustc), but defaults to true for backward
# compatibility. Ignored on non OSX.
, stripPrefix ? true
, disableInitExecTls ? false
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "jemalloc-${version}";
  inherit version;

  src = fetchurl {
    url = "https://github.com/jemalloc/jemalloc/releases/download/${version}/${name}.tar.bz2";
    inherit sha256;
  };

  # see the comment on stripPrefix
  configureFlags = []
    ++ optional (stdenv.isDarwin && stripPrefix) [ "--with-jemalloc-prefix=" ]
    ++ optional disableInitExecTls [ "--disable-initial-exec-tls" ]
  ;

  doCheck = true;

  enableParallelBuilding = true;

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
