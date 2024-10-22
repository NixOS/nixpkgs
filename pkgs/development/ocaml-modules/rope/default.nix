{ lib, fetchurl, fetchpatch, ocaml, buildDunePackage
, version ? if lib.versionAtLeast ocaml.version "5.0" then "0.6.3" else "0.6.2"
, benchmark
}:


buildDunePackage {
  pname = "rope";
  inherit version;
  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/Chris00/ocaml-rope/releases/download/${version}/rope-${version}.tbz";
    hash = {
      "0.6.2" = "sha256:15cvfa0s1vjx7gjd07d3fkznilishqf4z4h2q5f20wm9ysjh2h2i";
      "0.6.3" = "sha256-M14fiP9BDiz3WEoMqAJqZaXk4PoZ8Z1YjOk+F97z05Y=";
    }."${version}";
  };

  buildInputs = [ benchmark ] ;

  patches = lib.optional (version == "0.6.3") (fetchpatch {
    url = "https://github.com/Chris00/ocaml-rope/commit/be53daa18dd3d1450a92881b33c997eafb1dc958.patch";
    hash = "sha256-fHJNfD1ph3+QLmVJ8C4hhJ8hvrWIh7D0EL0XhOW2yqQ=";
  });

  meta = {
    homepage = "https://github.com/Chris00/ocaml-rope";
    description = "Ropes (“heavyweight strings”) in OCaml";
    license = lib.licenses.lgpl21;
    maintainers = [ ];
  };
}
