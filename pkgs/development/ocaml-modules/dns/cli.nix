{ buildDunePackage, dns, dns-tsig, dns-client, dns-server, dns-certify
, bos, cmdliner, fpath, x509, mirage-crypto, mirage-crypto-pk
, mirage-crypto-rng, hex, ptime, mtime, logs, fmt, ipaddr, lwt
, randomconv, alcotest
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
    dns-client
    dns-server
    dns-certify
    bos
    cmdliner
    fpath
    x509
    mirage-crypto
    mirage-crypto-pk
    mirage-crypto-rng
    hex
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
