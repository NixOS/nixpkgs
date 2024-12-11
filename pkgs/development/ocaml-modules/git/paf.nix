{
  buildDunePackage,
  git,
  mimic,
  paf,
  ca-certs-nss,
  fmt,
  ipaddr,
  logs,
  lwt,
  mirage-clock,
  mirage-time,
  rresult,
  tls,
  uri,
  bigstringaf,
  domain-name,
  httpaf,
  mirage-flow,
  tls-mirage,
}:

buildDunePackage {
  pname = "git-paf";

  inherit (git) version src;

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    git
    mimic
    paf
    ca-certs-nss
    fmt
    lwt
    rresult
    ipaddr
    logs
    mirage-clock
    mirage-time
    tls
    uri
    bigstringaf
    domain-name
    httpaf
    mirage-flow
    tls-mirage
  ];

  meta = git.meta // {
    description = "Package to use HTTP-based ocaml-git with MirageOS backend";
  };
}
