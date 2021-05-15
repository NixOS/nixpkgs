{ lib
, fetchurl
, buildDunePackage
, ounit
}:

buildDunePackage rec {
  pname = "sha";
  version = "1.13";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/djs55/ocaml-${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "00z2s4fsv9i1h09rj5dy3nd9hhcn79b75sn2ljj5wihlf4y4g304";
  };

  doCheck = true;
  checkInputs = [ ounit ];

  meta = with lib; {
    description = "Binding for SHA interface code in OCaml";
    maintainers = [ maintainers.arthurteisseire ];
    homepage = "https://github.com/djs55/ocaml-${pname}";
    license = licenses.isc;
  };

}
