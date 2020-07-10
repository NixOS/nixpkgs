{ stdenv, fetchurl, fetchzip, ocaml, findlib, tcl, tk }:

let OCamlVersionAtLeast = stdenv.lib.versionAtLeast ocaml.version; in

if !OCamlVersionAtLeast "4.04"
then throw "labltk is not available for OCaml ${ocaml.version}"
else

let param =
  let mkNewParam = { version, sha256 }: {
    inherit version;
    src = fetchzip {
      url = "https://github.com/garrigue/labltk/archive/${version}.tar.gz";
      inherit sha256;
    };
  }; in
  let mkOldParam = { version, key, sha256 }: {
    src = fetchurl {
      url = "https://forge.ocamlcore.org/frs/download.php/${key}/labltk-${version}.tar.gz";
      inherit sha256;
    };
    inherit version;
  }; in
 rec {
  "4.04" = mkOldParam {
    version = "8.06.2";
    key = "1628";
    sha256 = "1p97j9s33axkb4yyl0byhmhlyczqarb886ajpyggizy2br3a0bmk";
  };
  "4.05" = mkOldParam {
    version = "8.06.3";
    key = "1701";
    sha256 = "1rka9jpg3kxqn7dmgfsa7pmsdwm16x7cn4sh15ijyyrad9phgdxn";
  };
  "4.06" = mkOldParam {
    version = "8.06.4";
    key = "1727";
    sha256 = "0j3rz0zz4r993wa3ssnk5s416b1jhj58l6z2jk8238a86y7xqcii";
  };
  "4.07" = mkOldParam {
    version = "8.06.5";
    key = "1764";
    sha256 = "0wgx65y1wkgf22ihpqmspqfp95fqbj3pldhp1p3b1mi8rmc37zwj";
  };
  _8_06_7 = mkNewParam {
    version = "8.06.7";
    sha256 = "1cqnxjv2dvw9csiz4iqqyx6rck04jgylpglk8f69kgybf7k7xk2h";
  };
  "4.08" = _8_06_7;
  "4.09" = _8_06_7;
  "4.10" = mkNewParam {
    version = "8.06.8";
    sha256 = "0lfjc7lscq81ibqb3fcybdzs2r1i2xl7rsgi7linq46a0pcpkinw";
  };
}.${builtins.substring 0 4 ocaml.version};
in

stdenv.mkDerivation rec {
  inherit (param) version src;
  name = "ocaml${ocaml.version}-labltk-${version}";

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
