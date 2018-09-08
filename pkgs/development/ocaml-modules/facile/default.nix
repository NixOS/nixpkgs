{ stdenv, fetchurl, ocaml, findlib }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-facile-${version}";

  version = "1.1.3";

  src = fetchurl {
    url = "http://opti.recherche.enac.fr/facile/distrib/facile-${version}.tar.gz";
    sha256 = "1v4apqcw4gm36ph5xwf1wxaaza0ggvihvgsdslnf33fa1pdkvdjw";
  };

  dontAddPrefix = 1;

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  installFlags = [ "FACILEDIR=$(OCAMLFIND_DESTDIR)/facile" ];

  postInstall = ''
    cat > $OCAMLFIND_DESTDIR/facile/META <<EOF
    version = "${version}"
    name = "facile"
    description = "A Functional Constraint Library"
    requires = ""
    archive(byte) = "facile.cma"
    archive(native) = "facile.cmxa"
    EOF
  '';

  meta = {
    homepage = http://opti.recherche.enac.fr/facile/;
    license = stdenv.lib.licenses.lgpl21Plus;
    description = "A Functional Constraint Library";
    platforms = stdenv.lib.platforms.unix;
  };
}
