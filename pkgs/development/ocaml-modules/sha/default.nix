{ lib, fetchurl, buildDunePackage, stdlib-shims, dune-configurator, ounit }:

buildDunePackage rec {
  pname = "sha";
  version = "1.15.1";

  src = fetchurl {
    url = "https://github.com/djs55/ocaml-${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "sha256-cRtjydvwgXgimi6F3C48j7LrWgfMO6m9UJKjKlxvp0Q=";
  };

  useDune2 = true;

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [
    stdlib-shims
  ];

  doCheck = true;
  checkInputs = [
    ounit
  ];

  meta = with lib; {
    description = "Binding for SHA interface code in OCaml";
    homepage = "https://github.com/djs55/ocaml-sha/";
    license = licenses.isc;
    maintainers = with maintainers; [ arthurteisseire ];
  };
}
