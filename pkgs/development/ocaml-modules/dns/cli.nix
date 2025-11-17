{
  buildDunePackage,
  dns,
  dns-tsig,
  dns-client-lwt,
  dns-server,
  dns-certify,
  dns-resolver,
  dnssec,
  bos,
  cmdliner,
  fpath,
  x509,
  mirage-crypto,
  mirage-crypto-pk,
  mirage-crypto-rng,
  mirage-mtime,
  ohex,
  ptime,
  mtime,
  logs,
  fmt,
  ipaddr,
  lwt,
  randomconv,
  alcotest,
}:

buildDunePackage {
  pname = "dns-cli";

  minimalOCamlVersion = "4.08";

  inherit (dns) version src;

  # no need to propagate as this is primarily
  # an executable package
  buildInputs = [
    dns
    dns-tsig
    dns-client-lwt
    dns-server
    dns-certify
    dns-resolver
    dnssec
    bos
    cmdliner
    fpath
    x509
    mirage-crypto
    mirage-crypto-pk
    mirage-crypto-rng
    mirage-mtime
    ohex
    ptime
    mtime
    logs
    fmt
    ipaddr
    lwt
    randomconv
  ];

  doCheck = true;
  checkInputs = [
    alcotest
  ];

  meta = dns.meta // {
    description = "Unix command line utilities using uDNS";
    mainProgram = "odns";
  };
}
