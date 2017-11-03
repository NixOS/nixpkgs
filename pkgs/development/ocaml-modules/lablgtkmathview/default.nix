{stdenv, fetchurl, pkgconfig, ocaml, findlib, gmetadom, gtkmathview, lablgtk }:

let
  pname = "lablgtkmathview";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "0.7.2";

  src = fetchurl {
    url = "http://helm.cs.unibo.it/mml-widget/sources/${pname}-${version}.tar.gz";
    sha256 = "0rgrpgwrgphw106l1xawxir002b7rmzc23rcxhv8ib6rymp1divx";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ocaml findlib gmetadom gtkmathview lablgtk];

  createFindlibDestdir = true;

  propagatedBuildInputs = [gtkmathview];

  prePatch = ''
    substituteInPlace Makefile.in --replace "PROPCC = @OCAML_LIB_DIR@" "PROPCC = ${lablgtk}/lib/ocaml/${ocaml.version}/site-lib"
  '';

  buildPhase = ''
    mkdir -p .test
    make
    make opt
  '';

  meta = {
    homepage = http://helm.cs.unibo.it/mml-widget/;
    description = "OCaml bindings for gtkmathview";
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [ stdenv.lib.maintainers.roconnor ];
    broken = true;
  };
}
