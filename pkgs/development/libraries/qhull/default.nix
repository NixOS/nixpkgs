{stdenv, fetchurl, cmake}:

stdenv.mkDerivation rec {
  name = "qhull-2011.1";

  src = fetchurl {
    url = "${meta.homepage}/download/${name}-src.tgz";
    sha256 = "1i2lqw0552mvbcc1q7l4b31fpzf2l2qcabc23r4sybhwyljl9bmd";
  };

  buildNativeInputs = [ cmake ];

  cmakeFlags = "-DMAN_INSTALL_DIR=share/man/man1 -DDOC_INSTALL_DIR=share/doc/qhull";

  meta = {
    homepage = http://www.qhull.org/;
    description = "Computes the convex hull, Delaunay triangulation, ...";
    license = "free";
  };
}
