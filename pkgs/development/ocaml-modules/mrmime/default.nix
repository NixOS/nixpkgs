{
  afl-persistent,
  alcotest,
  angstrom,
  base64,
  bigarray-overlap,
  bigstringaf,
  buildDunePackage,
  cmdliner,
  emile,
  fetchurl,
  fpath,
  hxd,
  ipaddr,
  jsonm,
  ke,
  lib,
  mirage-crypto-rng,
  pecu,
  prettym,
  ptime,
  rosetta,
  unstrctrd,
  uutf,
}:

buildDunePackage rec {
  pname = "mrmime";
  version = "0.7.1";

  src = fetchurl {
    url = "https://github.com/mirage/mrmime/releases/download/v${version}/mrmime-${version}.tbz";
    hash = "sha256-H8VODo9SmHe9zLRUhL99cAm0Lp6jz7hVG5jDHip1/Ls=";
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
  # Checks are not compatible with mirage-crypto-rng ≥ 1.0
  doCheck = false;

  meta = {
    description = "Parser and generator of mail in OCaml";
    homepage = "https://github.com/mirage/mrmime";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mrmime.generate";
  };
}
