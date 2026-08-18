{
  fetchurl,
  buildDunePackage,
  lib,
  logs,
  fmt,
  h2,
  h1,
  ca-certs,
  bstr,
  tls-miou-unix,
  dns-client-miou-unix,
  happy-eyeballs-miou-unix,
  mirage-crypto-rng,
  alcotest,
  digestif,
}:

buildDunePackage (finalAttrs: {
  pname = "httpcats";
  version = "0.3.1";

  src = fetchurl {
    url = "https://github.com/robur-coop/httpcats/releases/download/v${finalAttrs.version}/httpcats-${finalAttrs.version}.tbz";
    hash = "sha256-5BymoyJS5JykTnSee0HhSKzbHkb8j6COuY7tZtGDGh0=";
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

  __darwinAllowLocalNetworking = true;

  doCheck = true;
  checkInputs = [
    logs
    fmt
    mirage-crypto-rng
    alcotest
    digestif
  ];

  meta = {
    homepage = "https://github.com/robur-coop/httpcats/";
    description = "A simple HTTP client / server using h1, h2, and miou";
    changelog = "https://github.com/robur-coop/httpcats/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rpqt ];
  };
})
