{stdenv, fetchurl, ocaml, findlib, ncurses, python, ocaml_make}:

# This is the original pycaml version with patches from debian.

let debian = fetchurl {
      url = "mirror://debian/pool/main/p/pycaml/pycaml_0.82-14.debian.tar.gz";
      sha256 = "a763088ec1fa76c769bf586ed6692e7ac035b0a2bfd48a90a8e7a9539ec0c2f1";
    };

in stdenv.mkDerivation {
  name = "pycaml-0.82-14";

  srcs = [
    (fetchurl {
      url = "mirror://debian/pool/main/p/pycaml/pycaml_0.82.orig.tar.gz";
      sha256 = "d57be559c8d586c575717d47817986bbdbcebe2ffd16ad6b291525c62868babe";
    })

    (fetchurl {
      url = "mirror://debian/pool/main/p/pycaml/pycaml_0.82-14.debian.tar.gz";
      sha256 = "a763088ec1fa76c769bf586ed6692e7ac035b0a2bfd48a90a8e7a9539ec0c2f1";
    })
  ];

  postPatch = ''
    rm -f Makefile* configure*
    cp ../debian/META ../debian/Makefile .
    sed -i "Makefile" -e's|/usr/share/ocamlmakefile/OCamlMakefile|${ocaml_make}/include/OCamlMakefile|g'
  '';

  sourceRoot = "pycaml";
  patches = [ "../debian/patches/*.patch" ];

  buildInputs = [ ncurses ocaml findlib python ocaml_make ];
  createFindlibDestdir = true;

  # the Makefile is not shipped with an install target, hence we do it ourselves.
  installPhase = ''
    ocamlfind install pycaml \
     dllpycaml_stubs.so libpycaml_stubs.a pycaml.a pycaml.cma \
     pycaml.cmi pycaml.cmo pycaml.cmx pycaml.cmxa \
     META
  '';

  meta = {
    homepage = "http://github.com/chemoelectric/pycaml";
    description = "Bindings for python and ocaml";
    license = "LGPL";
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
  };
}
