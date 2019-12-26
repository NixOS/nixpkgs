{ lib, fetchurl, buildDunePackage
, bigarray-compat, optint
, cmdliner, fmt, rresult
, alcotest
}:

buildDunePackage rec {
  version = "0.1.1";
  pname = "checkseum";

  src = fetchurl {
    url = "https://github.com/mirage/checkseum/releases/download/v${version}/checkseum-v${version}.tbz";
    sha256 = "0aa2r1l65a5hcgciw6n8r5ij4gpgg0cf9k24isybxiaiz63k94d3";
  };

  buildInputs = [ cmdliner fmt rresult ];
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
