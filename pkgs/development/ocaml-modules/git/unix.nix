{ buildDunePackage, git
, mmap, rresult, result, bigstringaf
, fmt, bos, fpath, uri, digestif, logs, lwt
, mirage-clock, mirage-clock-unix, astring, awa, cmdliner
, cohttp-lwt-unix, decompress, domain-name, ipaddr, mtime
, tcpip, awa-mirage, mirage-flow, mirage-unix
, alcotest, alcotest-lwt, base64, cstruct
, ke, mirage-crypto-rng, ocurl, git-binary
, ptime, mimic, ca-certs-nss, tls, tls-mirage
, cacert, happy-eyeballs-lwt, git-mirage
}:

buildDunePackage {
  pname = "git-unix";
  inherit (git) version src minimumOCamlVersion;

  buildInputs = [
    awa awa-mirage cmdliner
    mirage-clock tcpip
  ];
  propagatedBuildInputs = [
    mmap rresult result bigstringaf
    fmt bos fpath uri digestif logs lwt
    astring cohttp-lwt-unix decompress
    domain-name ipaddr mtime mirage-flow mirage-unix
    cstruct ptime mimic ca-certs-nss
    tls tls-mirage git happy-eyeballs-lwt
    git-mirage mirage-clock-unix
  ];
  checkInputs = [
    alcotest alcotest-lwt base64 ke
    mirage-crypto-rng git-binary
    cohttp-lwt-unix
    cacert # sets up NIX_SSL_CERT_FILE
  ];
  doCheck = true;

  meta = {
    description = "Unix backend for the Git protocol(s)";
    inherit (git.meta) homepage license maintainers;
  };
}
