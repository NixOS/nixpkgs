{ stdenv, fetchFromGitHub, which, ocaml, findlib, ocamlbuild, earley }:

stdenv.mkDerivation rec {
  version = "1.0.2";
  name = "ocaml${ocaml.version}-earley_ocaml-${version}";
  src = fetchFromGitHub {
    owner = "rlepigre";
    repo = "ocaml-earley-ocaml";
    rev = "ocaml-earley-ocaml_${version}";
    sha256 = "0f8kr49r2xfs7cbzps4r9i92ckhwssaiydam846jrky3z5djn2jc";
  };

  buildInputs = [ which ocaml findlib ocamlbuild ];

  propagatedBuildInputs = [ earley ];

  preBuild = "make";

  createFindlibDestdir = true;

  installFlags = [ "BINDIR=$(out)/bin" ];

  meta = {
    description = "Extensible OCaml parser to be used with Earley";
    license = stdenv.lib.licenses.cecill-b;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
    inherit (src.meta) homepage;
  };
}
