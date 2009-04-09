{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "qhull-2003.1";
  src = fetchurl {
    url = http://www.qhull.org/download/qhull-2003.1-src.tgz;
    sha256 = "1ah6yhh8qxqmvjcpmijibxcw8gjwvdcrb9g7j2rkawazq95a2j0s";
  };

  NIX_CFLAGS_COMPILE = "-fno-strict-aliasing " +
    (if stdenv.system == "x86_64-linux" then "-fPIC" else "");

  patchPhase = ''
    cd src
    sed -i -e "s@/usr/local@$out@" Makefile;
    sed -i -e "s@man/man1@share/man/man1@" Makefile;
  '';

  installPhase = ''
    ensureDir $out/bin
    ensureDir $out/include/qhull
    ensureDir $out/lib
    ensureDir $out/share/man/man1
    cp *.h $out/include/qhull
    cp libqhull.a $out/lib
  '';

  meta = {
    homepage = http://www.qhull.org/;
    description = "Computes the convex hull, Delaunay triangulation, ...";
    license = "free";
  };
}
