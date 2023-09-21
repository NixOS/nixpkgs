{ afl-persistent
, alcotest
, angstrom
, base64
, bigarray-compat
, bigarray-overlap
, bigstringaf
, buildDunePackage
, cmdliner
, emile
, fetchzip
, fmt
, fpath
, hxd
, ipaddr
, jsonm
, ke
, lib
, mirage-crypto-rng
, ocaml
, pecu
, prettym
, ptime
, rosetta
, rresult
, unstrctrd
, uutf
}:

buildDunePackage rec {
  pname = "mrmime";
  version = "0.5.0";

  src = fetchzip {
    url = "https://github.com/mirage/mrmime/releases/download/v${version}/mrmime-v${version}.tbz";
    sha256 = "14k67v0b39b8jq3ny2ymi8g8sqx2gd81mlzsjphdzdqnlx6fk716";
  };

  duneVersion = "3";

  buildInputs = [ cmdliner hxd ];

  propagatedBuildInputs = [
    angstrom
    base64
    emile
    fmt
    ipaddr
    ke
    pecu
    prettym
    ptime
    rosetta
    rresult
    unstrctrd
    uutf
    afl-persistent
    bigarray-compat
    bigarray-overlap
    bigstringaf
    fpath
    mirage-crypto-rng
  ];

  checkInputs = [
    alcotest
    jsonm
  ];
  doCheck = lib.versionOlder ocaml.version "5.0";

  meta = {
    description = "Parser and generator of mail in OCaml";
    homepage = "https://github.com/mirage/mrmime";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mrmime.generate";
  };
}
