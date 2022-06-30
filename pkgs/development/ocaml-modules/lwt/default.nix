{ lib, fetchFromGitHub, pkg-config, ncurses, libev, buildDunePackage, ocaml
, cppo, dune-configurator, ocplib-endian, result
, mmap, seq
, ocaml-syntax-shims
}:

let inherit (lib) optional versionOlder; in

buildDunePackage rec {
  pname = "lwt";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "lwt";
    rev = version;
    sha256 = "sha256:1jbjz2rsz3j56k8vh5qlmm87hhkr250bs2m3dvpy9vsri8rkzj9z";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config cppo ]
    ++ optional (versionOlder ocaml.version "4.08") ocaml-syntax-shims;
  buildInputs = [ dune-configurator ]
    ++ optional (versionOlder ocaml.version "4.07") ncurses;
  propagatedBuildInputs = [ libev mmap ocplib-endian seq result ];

  meta = {
    homepage = "https://ocsigen.org/lwt/";
    description = "A cooperative threads library for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
}
