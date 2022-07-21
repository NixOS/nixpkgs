{ buildDunePackage, dns, dns-tsig, dns-client, dns-server, dns-certify, dnssec
, cmdliner_1_1, fpath, x509, mirage-crypto, mirage-crypto-pk
, mirage-crypto-rng, hex, ptime, mtime, ipaddr, lwt
, randomconv, alcotest, callPackage
}:

buildDunePackage {
  pname = "dns-cli";

  minimalOCamlVersion = "4.08";

  inherit (dns) version src;

  # no need to propagate as this is primarily
  # an executable package
  buildInputs = [
    dns
    dnssec
    dns-tsig
    dns-client
    dns-server
    dns-certify
    # using call package as outlined in https://nixos.wiki/wiki/Nixpkgs/Modifying_Packages
    (callPackage ./bos.nix {} )
    cmdliner_1_1
    fpath
    x509
    mirage-crypto
    mirage-crypto-pk
    mirage-crypto-rng
    hex
    ptime
    mtime
    (callPackage ./logs.nix {})
    (callPackage ./fmt.nix {})
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
