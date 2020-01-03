{ lib, fetchurl, buildDunePackage
, cstruct, fmt
, bos, cmdliner, fpath, logs
, alcotest
}:

buildDunePackage rec {
  pname = "duff";
  version = "0.2";
  src = fetchurl {
    url = "https://github.com/mirage/duff/releases/download/v${version}/duff-v${version}.tbz";
    sha256 = "0bi081w4349cqc1n9jsjh1lrcqlnv3nycmvh9fniscv8lz1c0gjq";
  };

  buildInputs = [ bos cmdliner fpath logs ] ++ lib.optional doCheck alcotest;
  propagatedBuildInputs = [ cstruct fmt ];

  doCheck = true;

  meta = {
    description = "Pure OCaml implementation of libXdiff (Rabin’s fingerprint)";
    homepage = "https://github.com/mirage/duff";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
