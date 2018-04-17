{ stdenv, fetchurl, version, sha256, ... }@args:

stdenv.mkDerivation (rec {
  name = "jemalloc-${version}";
  inherit version;

  src = fetchurl {
    url = "https://github.com/jemalloc/jemalloc/releases/download/${version}/${name}.tar.bz2";
    inherit sha256;
  };

  # By default, jemalloc puts a je_ prefix onto all its symbols on OSX, which
  # then stops downstream builds (mariadb in particular) from detecting it. This
  # option should remove the prefix and give us a working jemalloc.
  configureFlags = stdenv.lib.optional stdenv.isDarwin "--with-jemalloc-prefix="
                   # jemalloc is unable to correctly detect transparent hugepage support on
                   # ARM (https://github.com/jemalloc/jemalloc/issues/526), and the default
                   # kernel ARMv6/7 kernel does not enable it, so we explicitly disable support
                   ++ stdenv.lib.optional stdenv.isArm "--disable-thp";
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
} // (builtins.removeAttrs args [ "stdenv" "fetchurl" "version" "sha256" ]))
