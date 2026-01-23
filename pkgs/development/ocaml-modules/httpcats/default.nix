{
  fetchFromGitHub,
  buildDunePackage,
  lib,
  logs,
  miou,
  fmt,
  h2,
  h1,
  ca-certs,
  bstr,
  tls-miou-unix,
  dns-client-miou-unix,
  happy-eyeballs-miou-unix,
  mirage-crypto-rng-miou-unix,
  alcotest,
  digestif,
}:

buildDunePackage (finalAttrs: {
  pname = "httpcats";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "robur-coop";
    repo = "httpcats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t3gSfv73XYntle1dd4k9bv893pGStk1NHz62mAvcHAs=";
  };

  propagatedBuildInputs = [
    h2
    h1
    ca-certs
    bstr
    tls-miou-unix
    dns-client-miou-unix
    happy-eyeballs-miou-unix
  ];

  doCheck = true;
  checkInputs = [
    logs
    fmt
    mirage-crypto-rng-miou-unix
    alcotest
    digestif
  ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "A simple HTTP client / server using h1, h2, and miou";
    changelog = "https://github.com/robur-coop/httpcats/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rpqt ];
  };
})
