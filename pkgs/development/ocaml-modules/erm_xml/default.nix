{
  stdenv,
  lib,
  fetchFromGitHub,
  ocaml,
  findlib,
  ocamlbuild,
}:

if lib.versionOlder ocaml.version "4.02" || lib.versionAtLeast ocaml.version "5.0" then
  throw "erm_xml is not available for OCaml ${ocaml.version}"
else

  stdenv.mkDerivation {
    pname = "ocaml${ocaml.version}-erm_xml";
    version = "0.3+20180112";

    src = fetchFromGitHub {
      owner = "hannesm";
      repo = "xml";
      rev = "bbabdade807d8281fc48806da054b70dfe482479";
      sha256 = "sha256-OQdLTq9tJZc6XlcuPv2gxzYiQAUGd6AiBzfSi169XL0=";
    };

    nativeBuildInputs = [
      ocaml
      findlib
      ocamlbuild
    ];

    strictDeps = true;

    createFindlibDestdir = true;

    meta = {
      homepage = "https://github.com/hannesm/xml";
      description = "XML Parser for discrete data";
      platforms = ocaml.meta.platforms or [ ];
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [ vbgl ];
    };
  }
