{ stdenv, fetchurl, python, cairomm, sparsehash, pycairo, autoreconfHook
, pkgconfig, boost, expat, scipy, cgal, gmp, mpfr
, gobject-introspection, pygobject3, gtk3, matplotlib, ncurses
, buildPythonPackage
, fetchpatch
}:

buildPythonPackage rec {
  pname = "graph-tool";
  format = "other";
  version = "2.27";

  meta = with stdenv.lib; {
    description = "Python module for manipulation and statistical analysis of graphs";
    homepage    = https://graph-tool.skewed.de/;
    license     = licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.joelmo ];
  };

  src = fetchurl {
    url = "https://downloads.skewed.de/graph-tool/graph-tool-${version}.tar.bz2";
    sha256 = "04s31qwlfcl7bwsggnic8gqcqmx2wsrmfw77nf7vzgnz42bwch27";
  };

  patches = [
    # fix build with cgal 4.13 (https://git.skewed.de/count0/graph-tool/issues/509)
    (fetchpatch {
      name = "cgal-4.13.patch";
      url = "https://git.skewed.de/count0/graph-tool/commit/aa39e4a6b42d43fac30c841d176c75aff92cc01a.patch";
      sha256 = "1578inb4jqwq2fhhwscn5z95nzmaxvmvk30nzs5wirr26iznap4m";
    })
  ];

  configureFlags = [
    "--with-python-module-path=$(out)/${python.sitePackages}"
    "--with-boost-libdir=${boost}/lib"
    "--with-expat=${expat}"
    "--with-cgal=${cgal}"
    "--enable-openmp"
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ ncurses ];

  propagatedBuildInputs = [
    boost
    cgal
    expat
    gmp
    mpfr
    python
    scipy
    # optional
    sparsehash
    # drawing
    cairomm
    gobject-introspection
    gtk3
    pycairo
    matplotlib
    pygobject3
  ];

  enableParallelBuilding = false;
}
