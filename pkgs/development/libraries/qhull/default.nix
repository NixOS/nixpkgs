{stdenv, fetchurl, cmake}:

stdenv.mkDerivation rec {
  name = "qhull-2012.1";

  src = fetchurl {
    url = "${meta.homepage}/download/${name}-src.tgz";
    sha256 = "19hb10vs7ww45ifn7mpvxykn470gd1g568d84mlld6v4pnz7gamv";
  };

  buildNativeInputs = [ cmake ];

  cmakeFlags = "-DMAN_INSTALL_DIR=share/man/man1 -DDOC_INSTALL_DIR=share/doc/qhull";

  meta = {
    homepage = http://www.qhull.org/;
    description = "Computes the convex hull, Delaunay triangulation, ...";
    license = "free";
  };
}
