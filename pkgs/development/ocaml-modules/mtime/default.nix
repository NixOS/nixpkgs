{
  stdenv,
  lib,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
}:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.08")
  "mtime is not available for OCaml ${ocaml.version}"

  stdenv.mkDerivation
  rec {
    pname = "ocaml${ocaml.version}-mtime";
    version = "2.1.0";

    src = fetchurl {
      url = "https://erratique.ch/software/mtime/releases/mtime-${version}.tbz";
      sha256 = "sha256-CXyygC43AerZVy4bSD1aKMbi8KOUSfqvm0StiomDTYg=";
    };

    nativeBuildInputs = [
      ocaml
      findlib
      ocamlbuild
      topkg
    ];
    buildInputs = [ topkg ];

    strictDeps = true;

    inherit (topkg) buildPhase installPhase;

    meta = with lib; {
      description = "Monotonic wall-clock time for OCaml";
      homepage = "https://erratique.ch/software/mtime";
      inherit (ocaml.meta) platforms;
      maintainers = [ maintainers.vbgl ];
      license = licenses.bsd3;
    };
  }
