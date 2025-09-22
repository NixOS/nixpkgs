{
  lib,
  stdenv,
  cmdliner,
  fetchurl,
  findlib,
  ocaml,
  ocamlbuild,
  topkg,
}:

if lib.versionOlder ocaml.version "4.14.0" then
  throw "cmarkit is not available for OCaml ${ocaml.version}"
else

  stdenv.mkDerivation rec {
    pname = "cmarkit";
    version = "0.3.0";

    src = fetchurl {
      url = "https://erratique.ch/software/cmarkit/releases/cmarkit-${version}.tbz";
      hash = "sha256-RouM5iU7VeTT0+4yhBgdEmxROeP/X31iqDjd1VI7z5c=";
    };

    nativeBuildInputs = [
      ocaml
      findlib
      ocamlbuild
      topkg
    ];

    buildInputs = [
      topkg
      cmdliner
    ];

    strictDeps = true;

    inherit (topkg) buildPhase installPhase;

    meta = with lib; {
      description = "CommonMark parser and renderer for OCaml";
      homepage = "https://erratique.ch/software/cmarkit";
      changelog = "https://github.com/dbuenzli/cmarkit/blob/v${version}/CHANGES.md";
      license = licenses.isc;
      maintainers = [ ];
      inherit (ocaml.meta) platforms;
    };
  }
