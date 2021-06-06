{ lib, fetchzip, buildDunePackage, ocaml }:

buildDunePackage rec {
  pname = "integers";
  version = "0.4.0";

  useDune2 = lib.versionAtLeast ocaml.version "4.08";

  src = fetchzip {
    url = "https://github.com/ocamllabs/ocaml-integers/archive/${version}.tar.gz";
    sha256 = "0yp3ab0ph7mp5741g7333x4nx8djjvxzpnv3zvsndyzcycspn9dd";
  };

  meta = {
    description = "Various signed and unsigned integer types for OCaml";
    license = lib.licenses.mit;
    homepage = "https://github.com/ocamllabs/ocaml-integers";
    maintainers = [ lib.maintainers.vbgl ];
  };
}
