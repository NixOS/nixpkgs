{ lib, stdenv, fetchurl, buildDunePackage, pkg-config, gsl, darwin, dune-configurator }:

buildDunePackage rec {
  pname = "gsl";
  version = "1.24.3";

  useDune2 = true;

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mmottl/gsl-ocaml/releases/download/${version}/gsl-${version}.tbz";
    sha256 = "1mpzcgbrha2l8iikqbmn32668v2mnnsykxg5n5jgs0qnskn2nvrn";
  };

  buildInputs = [ dune-configurator gsl pkg-config ];
  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Accelerate ];

  meta = with lib; {
    homepage = "https://mmottl.github.io/gsl-ocaml/";
    description = "OCaml bindings to the GNU Scientific Library";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vbgl ];
  };
}
