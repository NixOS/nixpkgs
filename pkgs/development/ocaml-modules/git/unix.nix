{ buildDunePackage, git
, mmap, rresult, result, bigstringaf
, fmt, bos, fpath, uri, digestif, logs, lwt
, mirage-clock, mirage-clock-unix, astring, awa, cmdliner_1_1
, cohttp-lwt-unix, decompress, domain-name, ipaddr, mtime, happy-eyeballs-lwt, mirage-unix
, tcpip, awa-mirage, mirage-flow
, alcotest, alcotest-lwt, base64, cstruct
, ke, mirage-crypto-rng, ocurl, git-binary
, ptime, mimic, mimic-happy-eyeballs, ca-certs-nss, tls, tls-mirage
, cacert, git-mirage, hex, git-paf, mirage-time
}:

buildDunePackage {
  pname = "git-unix";
  inherit (git) version src minimumOCamlVersion;

  useDune2 = true;

  propagatedBuildInputs = [
    rresult result bigstringaf
    fmt bos fpath uri digestif logs lwt
    astring decompress
    domain-name ipaddr mtime mirage-flow
    cstruct ptime mimic mimic-happy-eyeballs ca-certs-nss
    tls tls-mirage git-mirage hex git-paf mirage-time
    happy-eyeballs-lwt  mirage-unix awa awa-mirage cmdliner_1_1 git
    mirage-clock mirage-clock-unix tcpip
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
