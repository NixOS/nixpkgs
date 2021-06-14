{ lib, fetchurl, buildDunePackage, stdlib-shims, ounit }:

buildDunePackage rec {
  pname = "sha";
  version = "1.14";

  src = fetchurl {
    url = "https://github.com/djs55/ocaml-${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "114vydrfdp7fayigvgk3ckiby0kh4n49c1j53v8k40gk6nzm3l19";
  };

  useDune2 = true;

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
