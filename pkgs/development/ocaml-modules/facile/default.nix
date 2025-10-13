{
  lib,
  fetchurl,
  buildDunePackage,
  ocaml,
}:

lib.throwIf (lib.versionAtLeast ocaml.version "5.0") "facile is not available for OCaml ≥ 5.0"

  buildDunePackage
  rec {
    pname = "facile";
    version = "1.1.4";

    src = fetchurl {
      url = "https://github.com/Emmanuel-PLF/facile/releases/download/${version}/facile-${version}.tbz";
      sha256 = "0jqrwmn6fr2vj2rrbllwxq4cmxykv7zh0y4vnngx29f5084a04jp";
    };

    doCheck = true;

    duneVersion = if lib.versionAtLeast ocaml.version "4.12" then "2" else "1";
    postPatch = lib.optionalString (duneVersion != "1") "dune upgrade";

    meta = {
      homepage = "http://opti.recherche.enac.fr/facile/";
      license = lib.licenses.lgpl21Plus;
      description = "Functional Constraint Library";
    };
  }
