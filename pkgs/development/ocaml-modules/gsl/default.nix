{ lib, fetchurl, buildDunePackage, pkg-config, gsl
, dune-configurator
}:

buildDunePackage rec {
  pname = "gsl";
  version = "1.24.3";

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mmottl/gsl-ocaml/releases/download/${version}/gsl-${version}.tbz";
    sha256 = "1mpzcgbrha2l8iikqbmn32668v2mnnsykxg5n5jgs0qnskn2nvrn";
  };

  buildInputs = [ dune-configurator gsl pkg-config ];

  meta = {
    homepage = "https://mmottl.github.io/gsl-ocaml/";
    description = "OCaml bindings to the GNU Scientific Library";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
