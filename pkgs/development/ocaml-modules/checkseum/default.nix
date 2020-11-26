{ lib, fetchurl, buildDunePackage, dune-configurator
, bigarray-compat, optint
, fmt, rresult
, alcotest
}:

buildDunePackage rec {
  version = "0.2.1";
  pname = "checkseum";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/checkseum/releases/download/v${version}/checkseum-v${version}.tbz";
    sha256 = "1swb44c64pcs4dh9ka9lig6d398qwwkd3kkiajicww6qk7jbh3n5";
  };

  buildInputs = [ dune-configurator fmt rresult ];
  propagatedBuildInputs = [ bigarray-compat optint ];
  checkInputs = lib.optionals doCheck [ alcotest ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/mirage/checkseum";
    description = "ADLER-32 and CRC32C Cyclic Redundancy Check";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
