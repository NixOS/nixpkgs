{
  lib,
  buildDunePackage,
  fetchurl,
  digestif,
  mirage-ptime,
  x509,
  logs,
  fmt,
  bos,
  cmdliner,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "ca-certs-nss";
  version = "3.118";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/mirage/ca-certs-nss/releases/download/v${finalAttrs.version}/ca-certs-nss-${finalAttrs.version}.tbz";
    hash = "sha256-BthKUUeuf3jFRmQzw0U9SEbvRqcVc1UKHmb4+YePRio=";
  };

  propagatedBuildInputs = [
    mirage-ptime
    x509
    digestif
  ];

  buildInputs = [
    logs
    fmt
    bos
    cmdliner
  ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "X.509 trust anchors extracted from Mozilla's NSS";
    homepage = "https://github.com/mirage/ca-certs-nss";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.sternenseemann ];
    mainProgram = "extract-from-certdata";
  };
})
