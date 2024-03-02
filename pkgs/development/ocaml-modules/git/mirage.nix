{ lib
, buildDunePackage
, git
, mimic
, mimic-happy-eyeballs
, base64
, git-paf
, awa
, awa-mirage
, dns
, dns-client
, tls
, tls-mirage
, uri
, hex
, happy-eyeballs-mirage
, happy-eyeballs
, ca-certs-nss
, mirage-crypto
, ptime
, x509
, cstruct
, tcpip
, domain-name
, fmt
, ipaddr
, lwt
, mirage-clock
, mirage-flow
, mirage-random
, mirage-time
, result
, rresult
, alcotest
, alcotest-lwt
, bigstringaf
, logs
, ke
}:

buildDunePackage {
  pname = "git-mirage";

  inherit (git) version src;

  minimalOCamlVersion = "4.08";

  buildInputs = [
    dns
    dns-client
    happy-eyeballs-mirage
    ipaddr
    mirage-random
    rresult
  ];

  propagatedBuildInputs = [
    git
    mimic
    mimic-happy-eyeballs
    base64
    git-paf
    awa
    awa-mirage
    tls
    tls-mirage
    uri
    hex
    happy-eyeballs
    ca-certs-nss
    mirage-crypto
    ptime
    x509
    cstruct
    tcpip
    domain-name
    fmt
    lwt
    mirage-clock
    mirage-flow
    mirage-time
    result
  ];

  checkInputs = [
    alcotest
    alcotest-lwt
    bigstringaf
    logs
    ke
  ];

  meta = git.meta // {
    description = "A package to use ocaml-git with MirageOS backend";
  };
}
