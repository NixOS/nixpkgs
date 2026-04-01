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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "robur-coop";
    repo = "httpcats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-19WV5pabmeuYmcW3AbnVpT30Sx6TVAPH+ayEeJgRS0Q=";
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
