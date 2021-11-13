{ lib, fetchzip, pkg-config, ncurses, libev, buildDunePackage, ocaml
, cppo, dune-configurator, ocplib-endian, result
, mmap, seq
, ocaml-syntax-shims
}:

let inherit (lib) optional versionAtLeast; in

buildDunePackage rec {
  pname = "lwt";
  version = "5.4.1";

  useDune2 = true;

  src = fetchzip {
    url = "https://github.com/ocsigen/${pname}/archive/${version}.tar.gz";
    sha256 = "0cq2qy23sa1a5zk6nja3c652mp29i84yfrkcwks6i8sdqwli36jy";
  };

  nativeBuildInputs = [ pkg-config cppo dune-configurator ];
  buildInputs = optional (!versionAtLeast ocaml.version "4.08") ocaml-syntax-shims
   ++ optional (!versionAtLeast ocaml.version "4.07") ncurses;
  propagatedBuildInputs = [ libev mmap ocplib-endian seq result ];

  meta = {
    homepage = "https://ocsigen.org/lwt/";
    description = "A cooperative threads library for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
}
