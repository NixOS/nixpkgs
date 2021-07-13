{ buildDunePackage
, lib
, fetchurl
, angstrom
, faraday
}:

buildDunePackage rec {
  pname = "hpack";
  version = "0.8.0";

  src = fetchurl {
    url = "https://github.com/anmonteiro/ocaml-h2/releases/download/${version}/h2-${version}.tbz";
    sha256 = "0qcn3yvyz0h419fjg9nb20csfmwmh3ihz0zb0jfzdycf5w4mlry6";
  };

  useDune2 = true;
  minimumOCamlVersion = "4.04";

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
