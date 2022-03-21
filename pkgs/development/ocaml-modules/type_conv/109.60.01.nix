{ stdenv, lib, fetchFromGitHub, ocaml, findlib, camlp4 }:

if !lib.versionAtLeast ocaml.version "4.00"
  || lib.versionAtLeast ocaml.version "4.03"
then throw "type_conv-109.60.01 is not available for OCaml ${ocaml.version}" else

stdenv.mkDerivation rec {
  pname = "ocaml-type_conv";
  version = "109.60.01";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "type_conv";
    rev = version;
    sha256 = "sha256-8Oz/fPL3+RghyxQp5u6seSEdf0BgfP6XNcsMYty0rNs=";
  };

  nativeBuildInputs = [ ocaml findlib ];
  buildInputs = [ camlp4 ];

  strictDeps = true;

  createFindlibDestdir = true;

  meta = {
    homepage = "http://forge.ocamlcore.org/projects/type-conv/";
    description = "Support library for OCaml preprocessor type conversions";
    license = lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms or [ ];
    maintainers = with lib.maintainers; [ maggesi ];
  };
}
