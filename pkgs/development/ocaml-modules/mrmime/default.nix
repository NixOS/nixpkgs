{ afl-persistent
, alcotest
, angstrom
, base64
, bigarray-compat
, bigarray-overlap
, bigstringaf
, buildDunePackage
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

  useDune2 = true;

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
    hxd
    jsonm
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
