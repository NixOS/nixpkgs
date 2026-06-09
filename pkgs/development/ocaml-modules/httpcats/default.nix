{
  fetchpatch2,
  fetchzip,
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
  mirage-crypto-rng-miou-unix,
  alcotest,
  digestif,
}:

buildDunePackage (finalAttrs: {
  pname = "httpcats";
  version = "0.2.1";

  src = fetchzip {
    url = "https://github.com/robur-coop/httpcats/releases/download/v${finalAttrs.version}/httpcats-${finalAttrs.version}.tbz";
    hash = "sha256-ehtwxQGHw8igzI0dy2Zzs+VOqvck/tAUuuJl+jSpVU8=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/robur-coop/httpcats/commit/d8787555d4831e0488780d42bd2c65de662d1d38.patch";
      hash = "sha256-6zXPb+mvw2rcEMv28b0npcL8cKl3CASxDbl7FOAGsXs=";
    })
  ];

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
    mirage-crypto-rng-miou-unix
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
