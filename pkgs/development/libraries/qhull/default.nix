{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "qhull-2010.1";
  src = fetchurl {
    url = http://www.qhull.org/download/qhull-2010.1-src.tgz;
    sha256 = "1ghnwci1s56yzzwg8gmlzhsd5v3imsqxf24yb0j5m6qv8kxqaw2m";
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
    cp qconvex qdelaunay qhalf qhull rbox qvoronoi $out/bin
    cp *.h $out/include/qhull
    cp libqhull.a $out/lib
  '';

  meta = {
    homepage = http://www.qhull.org/;
    description = "Computes the convex hull, Delaunay triangulation, ...";
    license = "free";
  };
}
