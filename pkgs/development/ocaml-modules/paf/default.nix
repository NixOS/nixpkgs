{
  buildDunePackage,
  lib,
  fetchurl,
  h1,
  h2,
  tls-mirage,
  mimic,
  ke,
  bigstringaf,
  faraday,
  tls,
  lwt,
  logs,
  fmt,
  mirage-crypto-rng,
  tcpip,
  ptime,
  uri,
  alcotest-lwt,
  cstruct,
}:

buildDunePackage rec {
  pname = "paf";
  version = "0.8.0";

  src = fetchurl {
    url = "https://github.com/dinosaure/paf-le-chien/releases/download/${version}/paf-${version}.tbz";
    hash = "sha256-0q07gZpzUyDoWlA4m/P+EGSvvVKAZ7RwVkpOziqzG2M=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    h1
    h2
    tls-mirage
    mimic
    ke
    bigstringaf
    faraday
    tls
    cstruct
    tcpip
  ];

  doCheck = true;
  checkInputs = [
    lwt
    logs
    fmt
    mirage-crypto-rng
    ptime
    uri
    alcotest-lwt
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "HTTP/AF and MirageOS";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sternenseemann ];
    homepage = "https://github.com/dinosaure/paf-le-chien";
  };
}
