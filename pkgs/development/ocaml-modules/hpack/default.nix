{ buildDunePackage
, lib
, fetchurl
, angstrom
, faraday
}:

buildDunePackage rec {
  pname = "hpack";
  version = "0.9.0";

  src = fetchurl {
    url = "https://github.com/anmonteiro/ocaml-h2/releases/download/${version}/h2-${version}.tbz";
    sha256 = "sha256-7gjRhJs2mufQbImAXiKFT9mZ1kHGSHHwjCVZM5f0C14=";
  };

  minimalOCamlVersion = "4.04";

  propagatedBuildInputs = [
    angstrom
    faraday
  ];

  # circular dependency
  doCheck = false;

  meta = {
    license = lib.licenses.bsd3;
    description = "An HPACK (Header Compression for HTTP/2) implementation in OCaml";
    homepage = "https://github.com/anmonteiro/ocaml-h2";
    maintainers = with lib.maintainers; [
      sternenseemann
      anmonteiro
    ];
  };
}
