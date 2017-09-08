{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libexecinfo-${version}";
  version = "1.1";

  src = fetchurl {
    url = "http://distcache.freebsd.org/local-distfiles/itetcu/${name}.tar.bz2";
    sha256 = "07wvlpc1jk1sj4k5w53ml6wagh0zm9kv2l1jngv8xb7xww9ik8n9";
  };

  patches = [
    ./10-execinfo.patch
    ./20-define-gnu-source.patch
    ./30-linux-makefile.patch
  ];

  patchFlags = "-p0";

  installPhase = ''
    install -Dm644 execinfo.h stacktraverse.h -t $out/include
    install -Dm755 libexecinfo.{a,so.1} -t $out/lib
    ln -s $out/lib/libexecinfo.so{.1,}
  '';
}
