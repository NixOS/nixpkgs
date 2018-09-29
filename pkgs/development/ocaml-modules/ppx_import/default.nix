{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, opaline
, cppo, ounit, ppx_deriving
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "ppx_import is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ppx_import-${version}";

  version = "1.5";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = "ppx_import";
    rev = "v${version}";
    sha256 = "1lf5lfp6bl5g4gdszaa6k6pkyh3qyhbarg5m1j0ai3i8zh5qg09d";
  };

  buildInputs = [ ocaml findlib ocamlbuild cppo ounit ppx_deriving opaline ];

  doCheck = true;
  checkTarget = "test";

  installPhase = "opaline -prefix $out -libdir $OCAMLFIND_DESTDIR";

  meta = with stdenv.lib; {
    description = "A syntax extension that allows to pull in types or signatures from other compiled interface files";
    license = licenses.mit;
    inherit (ocaml.meta) platforms;
    inherit (src.meta) homepage;
  };
}
