{ stdenv, fetchurl, ocaml, findlib, tcl, tk }:

if !stdenv.lib.versionAtLeast ocaml.version "4.04"
then throw "labltk is not available for OCaml ${ocaml.version}"
else

let param = {
  "4.04" = {
    version = "8.06.2";
    key = "1628";
    sha256 = "1p97j9s33axkb4yyl0byhmhlyczqarb886ajpyggizy2br3a0bmk";
  };
  "4.05" = {
    version = "8.06.3";
    key = "1701";
    sha256 = "1rka9jpg3kxqn7dmgfsa7pmsdwm16x7cn4sh15ijyyrad9phgdxn";
  };
  "4.06" = {
    version = "8.06.4";
    key = "1727";
    sha256 = "0j3rz0zz4r993wa3ssnk5s416b1jhj58l6z2jk8238a86y7xqcii";
  };
  "4.07" = {
    version = "8.06.5";
    key = "1764";
    sha256 = "0wgx65y1wkgf22ihpqmspqfp95fqbj3pldhp1p3b1mi8rmc37zwj";
  };
}."${builtins.substring 0 4 ocaml.version}";
in

stdenv.mkDerivation rec {
  inherit (param) version;
  name = "ocaml${ocaml.version}-labltk-${version}";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/${param.key}/labltk-${param.version}.tar.gz";
    inherit (param) sha256;
  };

  buildInputs = [ ocaml findlib tcl tk ];

  configureFlags = [ "--use-findlib" "--installbindir" "$(out)/bin" ];
  dontAddPrefix = true;

  buildFlags = [ "all" "opt" ];

  createFindlibDestdir = true;

  postInstall = ''
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
    mv $OCAMLFIND_DESTDIR/labltk/dlllabltk.so $OCAMLFIND_DESTDIR/stublibs/
  '';

  meta = {
    description = "OCaml interface to Tcl/Tk, including OCaml library explorer OCamlBrowser";
    homepage = "http://labltk.forge.ocamlcore.org/";
    license = stdenv.lib.licenses.lgpl21;
    inherit (ocaml.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
