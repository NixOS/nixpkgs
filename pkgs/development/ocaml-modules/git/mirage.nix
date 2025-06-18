{
  buildDunePackage,
  git,
  mimic,
  mimic-happy-eyeballs,
  base64,
  git-paf,
  awa,
  awa-mirage,
  tls,
  tls-mirage,
  uri,
  happy-eyeballs-mirage,
  happy-eyeballs,
  ca-certs-nss,
  mirage-crypto,
  ptime,
  x509,
  cstruct,
  tcpip,
  domain-name,
  fmt,
  ipaddr,
  lwt,
  mirage-flow,
  mirage-ptime,
  mirage-sleep,
  alcotest,
  alcotest-lwt,
  bigstringaf,
  logs,
  ke,
}:

buildDunePackage {
  pname = "git-mirage";

  inherit (git) version src;

  minimalOCamlVersion = "4.08";

  buildInputs = [
    happy-eyeballs-mirage
    ipaddr
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
    mirage-ptime
    mirage-flow
    mirage-sleep
  ];

  checkInputs = [
    alcotest
    alcotest-lwt
    bigstringaf
    logs
    ke
  ];

  meta = git.meta // {
    description = "Package to use ocaml-git with MirageOS backend";
  };
}
