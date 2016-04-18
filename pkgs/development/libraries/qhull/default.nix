{stdenv, fetchurl, cmake}:

stdenv.mkDerivation rec {
  name = "qhull-2012.1";

  src = fetchurl {
    url = "${meta.homepage}/download/${name}-src.tgz";
    sha256 = "127zpjp6sm8c101hz239k82lpxqcqf4ksdyfqc2py2sm22kclpm3";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = "-DMAN_INSTALL_DIR=share/man/man1 -DDOC_INSTALL_DIR=share/doc/qhull";

  hardeningDisable = [ "format" ];

  patchPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's/namespace std { struct bidirectional_iterator_tag; struct random_access_iterator_tag; }/#include <iterator>/' ./src/libqhullcpp/QhullIterator.h
    sed -i 's/namespace std { struct bidirectional_iterator_tag; struct random_access_iterator_tag; }/#include <iterator>/' ./src/libqhullcpp/QhullLinkedList.h
  '';

  meta = {
    homepage = http://www.qhull.org/;
    description = "Computes the convex hull, Delaunay triangulation, Voronoi diagram and more";
    license = stdenv.lib.licenses.free;
  };
}
