{ lib, fetchFromGitHub, pkg-config, ncurses, libev, buildDunePackage, ocaml
, cppo, dune-configurator, ocplib-endian, result
, mmap, seq
, ocaml-syntax-shims
}:

let inherit (lib) optional versionAtLeast; in

buildDunePackage rec {
  pname = "lwt";
  version = "5.4.1";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "lwt";
    rev = version;
    sha256 = "sha256-XpoRKcdNo2j05Gxm5wmKSdwqimFDSWvmLyooPYTHAjM=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config cppo ]
    ++ optional (!versionAtLeast ocaml.version "4.08") ocaml-syntax-shims;
  buildInputs = [ dune-configurator ]
    ++ optional (!versionAtLeast ocaml.version "4.07") ncurses;
  propagatedBuildInputs = [ libev mmap ocplib-endian seq result ];

  meta = {
    homepage = "https://ocsigen.org/lwt/";
    description = "A cooperative threads library for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
}
