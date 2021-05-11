{ lib, buildDunePackage
, git
, mimic
, paf
, ca-certs-nss
, cohttp
, cohttp-lwt
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
}:

buildDunePackage {
  pname = "git-paf";

  inherit (git) version src minimumOCamlVersion useDune2;

  propagatedBuildInputs = [
    git
    mimic
    paf
    ca-certs-nss
    cohttp
    cohttp-lwt
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
  ];

  meta = git.meta // {
    description = "A package to use HTTP-based ocaml-git with MirageOS backend";
  };
}
