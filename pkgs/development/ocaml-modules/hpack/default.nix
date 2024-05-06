{ buildDunePackage
, lib
, fetchurl
, angstrom
, faraday
}:

buildDunePackage rec {
  pname = "hpack";
  version = "0.13.0";

  src = fetchurl {
    url = "https://github.com/anmonteiro/ocaml-h2/releases/download/${version}/h2-${version}.tbz";
    hash = "sha256-DYm28XgXUpTnogciO+gdW4P8Mbl1Sb7DTwQyo7KoBw8=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    angstrom
    faraday
  ];

  # circular dependency
  doCheck = false;

  meta = {
    license = lib.licenses.bsd3;
    description = "HPACK (Header Compression for HTTP/2) implementation in OCaml";
    homepage = "https://github.com/anmonteiro/ocaml-h2";
    maintainers = with lib.maintainers; [
      sternenseemann
      anmonteiro
    ];
  };
}
