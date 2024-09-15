{ afl-persistent
, alcotest
, angstrom
, base64
, bigarray-overlap
, bigstringaf
, buildDunePackage
, cmdliner
, emile
, fetchurl
, fpath
, hxd
, ipaddr
, jsonm
, ke
, lib
, mirage-crypto-rng
, pecu
, prettym
, ptime
, rosetta
, unstrctrd
, uutf
}:

buildDunePackage rec {
  pname = "mrmime";
  version = "0.6.1";

  src = fetchurl {
    url = "https://github.com/mirage/mrmime/releases/download/v${version}/mrmime-${version}.tbz";
    hash = "sha256-Dzsr7xPzu5RIzIdubF4OAAjHJY7CdBVnHRZxQbcCsBY=";
  };

  propagatedBuildInputs = [
    angstrom
    base64
    emile
    ipaddr
    ke
    pecu
    prettym
    ptime
    rosetta
    unstrctrd
    uutf
    bigarray-overlap
    bigstringaf
  ];

  checkInputs = [
    afl-persistent
    alcotest
    cmdliner
    fpath
    hxd
    jsonm
    mirage-crypto-rng
  ];
  doCheck = true;

  meta = {
    description = "Parser and generator of mail in OCaml";
    homepage = "https://github.com/mirage/mrmime";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mrmime.generate";
  };
}
