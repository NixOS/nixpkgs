{ lib, buildDunePackage
, git
, mimic
, paf
, ca-certs-nss
, fmt
, ipaddr
, logs
, lwt
, mirage-clock
, mirage-stack
, mirage-time
, result
, rresult
, tls
, uri
, bigarray-compat
, bigstringaf
, domain-name
, httpaf
, mirage-flow
, tls-mirage
}:

buildDunePackage {
  pname = "git-paf";

  inherit (git) version src minimumOCamlVersion useDune2;

  propagatedBuildInputs = [
    git
    mimic
    paf
    ca-certs-nss
    fmt
    lwt
    result
    rresult
    ipaddr
    logs
    mirage-clock
    mirage-stack
    mirage-time
    tls
    uri
    bigarray-compat
    bigstringaf
    domain-name
    httpaf
    mirage-flow
    tls-mirage
  ];

  meta = git.meta // {
    description = "A package to use HTTP-based ocaml-git with MirageOS backend";
  };
}
