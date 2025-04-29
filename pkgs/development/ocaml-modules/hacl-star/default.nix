{
  buildDunePackage,
  hacl-star-raw,
  zarith,
  cppo,
  alcotest,
  secp256k1-internal,
  qcheck-core,
  cstruct,
}:

buildDunePackage {
  pname = "hacl-star";

  inherit (hacl-star-raw)
    version
    src
    meta
    doCheck
    ;

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    hacl-star-raw
    zarith
  ];

  nativeBuildInputs = [
    cppo
  ];

  checkInputs = [
    alcotest
    secp256k1-internal
    qcheck-core
    cstruct
  ];
}
