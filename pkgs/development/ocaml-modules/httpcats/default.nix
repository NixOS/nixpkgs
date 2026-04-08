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
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "robur-coop";
    repo = "httpcats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I7u/n49WOnpc0EaagsjC4Ts/kz0Xj6YHZv6+QZKLrC4=";
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
    homepage = "https://github.com/robur-coop/httpcats/";
    description = "A simple HTTP client / server using h1, h2, and miou";
    changelog = "https://github.com/robur-coop/httpcats/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rpqt ];
  };
})
