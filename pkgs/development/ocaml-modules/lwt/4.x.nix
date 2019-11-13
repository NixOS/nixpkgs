{ lib, fetchzip, pkgconfig, ncurses, libev, buildDunePackage, ocaml
, cppo, ocaml-migrate-parsetree, ocplib-endian, result
, mmap, seq
}:

let inherit (lib) optional versionAtLeast; in

buildDunePackage rec {
  pname = "lwt";
  version = "4.4.0";

  src = fetchzip {
    url = "https://github.com/ocsigen/${pname}/archive/${version}.tar.gz";
    sha256 = "1l97zdcql7y13fhaq0m9n9xvxf712jg0w70r72fvv6j49xm4nlhi";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cppo ocaml-migrate-parsetree ]
   ++ optional (!versionAtLeast ocaml.version "4.07") ncurses;
  propagatedBuildInputs = [ libev mmap ocplib-endian seq result ];

  meta = {
    homepage = "https://ocsigen.org/lwt/";
    description = "A cooperative threads library for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
}
