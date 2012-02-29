{stdenv, fetchurl, ocaml, findlib, python, ocaml_make}:

# The actual version of pycaml is unclear, as it is the original
# 0.82 version with some patches applied in order to use it for
# the kompostilo type setter (see README). Apparently, some of
# the patches provide Python 3.1 support.
# This version also differs from the Debian version, which
# is also a heavily patched 0.82.
# Therefore, we may at some point try to find out what is
# actually the "real" version (if the library is still alive).

stdenv.mkDerivation {
  name = "pycaml-0.82";

  src = fetchurl {
    name = "pycaml.tar.gz";
    url = "http://github.com/chemoelectric/pycaml/tarball/master";
    sha256 = "ff6d863c42b4ef798f50ff5eff77b47b77b5c0d28b6f65364e8a436a216dc591";
  };

  buildInputs = [ocaml findlib python ocaml_make];

  createFindlibDestdir = true;

  phases = [ "unpackPhase" "patchPhase" "buildPhase" "installPhase" ];

  # fix some paths to the appropriate store paths.
  patchPhase = ''
    sed -i "Makefile" -e's|/usr/include/OCamlMakefile|${ocaml_make}/include/OCamlMakefile|g'
    sed -i "Makefile" -e's|/usr|${python}|g'
    '';

  buildPhase = ''
    make -f Makefile -j1 PYVER=`python -c 'import sys; print("{0}.{1}".format(sys.version_info.major, sys.version_info.minor));'`
    '';

  # the Makefile is not shipped with an install target, hence we do it ourselves.
  installPhase = ''
    ocamlfind install pycaml \
      dllpycaml_stubs.so* libpycaml_stubs.a pycaml.a pycaml.cma \
      pycaml.cmi pycaml.cmo pycaml.cmx pycaml.cmxa pycaml.ml pycaml.mli \
      pycaml.o pycaml_stubs.c pycaml_stubs.h pycaml_stubs.o META
    '';

  meta = {
    homepage = "http://github.com/chemoelectric/pycaml";
    description = "Bindings for python and ocaml";
    license = "LGPL";
    platforms = ocaml.meta.platforms;
  };
}
