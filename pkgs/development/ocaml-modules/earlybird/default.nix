{ lib, fetchurl, ocaml, buildDunePackage
, cmdliner, dap, fmt, iter, logs, lru, lwt_ppx, lwt_react, menhir, path_glob, ppx_deriving_yojson
}:

if lib.versionAtLeast ocaml.version "4.13"
then throw "earlybird is not available for OCaml ${ocaml.version}"
else

buildDunePackage rec {
  pname = "earlybird";
  version = "1.1.0";

  useDune2 = true;

  minimumOCamlVersion = "4.11";

  src = fetchurl {
    url = "https://github.com/hackwaly/ocamlearlybird/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "1pwzhcr3pw24ra4j4d23vz71h0psz4xkyp7b12l2wl1slxzjbrxa";
  };

  buildInputs = [ cmdliner dap fmt iter logs lru lwt_ppx lwt_react menhir path_glob ppx_deriving_yojson ];

  meta = {
    homepage = "https://github.com/hackwaly/ocamlearlybird";
    description = "OCaml debug adapter";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.romildo ];
  };
}
