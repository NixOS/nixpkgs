{ stdenv, fetchurl, fetchpatch, ocaml, findlib, ocamlbuild, which, camlp4 }:

let inherit (stdenv.lib) getVersion versionAtLeast; in

assert versionAtLeast (getVersion ocaml) "4.00.0";
assert versionAtLeast (getVersion findlib) "1.3.3";

if versionAtLeast ocaml.version "4.06"
then throw "bolt is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {

  name = "bolt-1.4";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1043/${name}.tar.gz";
    sha256 = "1c807wrpxra9sbb34lajhimwra28ldxv04m570567lh2b04n38zy";
  };

  buildInputs = [ ocaml findlib ocamlbuild which camlp4 ];

  patches = [ (fetchpatch {
      url = https://raw.githubusercontent.com/ocaml/opam-repository/master/packages/bolt/bolt.1.4/files/opam.patch;
      sha256 = "08cl39r98w312sw23cskd5wian6zg20isn9ki41hnbcgkazhi7pb";
    })
  ];

  postPatch = ''
    patch myocamlbuild.ml <<EOF
70,74c70
<         let camlp4of =
<           try
<             let path_bin = Filename.concat (Sys.getenv "PATH_OCAML_PREFIX") "bin" in
<             Filename.concat path_bin "camlp4of"
<           with _ -> "camlp4of" in
---
>         let camlp4of = "camlp4of" in
EOF
  '';

  # The custom `configure` script does not expect the --prefix
  # option. Installation is handled by ocamlfind.
  dontAddPrefix = true;

  createFindlibDestdir = true;

  buildFlags = "all";

  doCheck = true;
  checkTarget = "tests";

  meta = with stdenv.lib; {
    homepage = http://bolt.x9c.fr;
    description = "A logging tool for the OCaml language";
    longDescription = ''
      Bolt is a logging tool for the OCaml language. It is inspired by and
      modeled after the famous log4j logging framework for Java.
    '';
    license = licenses.lgpl3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.jirkamarsik ];
  };
}
