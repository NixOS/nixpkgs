{ buildDunePackage, mimic, mimic-happy-eyeballs, git, git-paf, awa, awa-mirage, dns, dns-client, tls,
tls-mirage, hex, happy-eyeballs, ca-certs-nss, mirage-crypto, ptime, x509, tcpip,
domain-name, fmt, ipaddr, lwt, mirage-clock, mirage-flow, mirage-random,
mirage-time, result, rresult, alcotest, alcotest-lwt, bigstringaf, logs, ke, cstruct
}:

buildDunePackage {
  pname = "git-mirage";
  inherit (git) version src minimumOCamlVersion;

  useDune2 = true;

  buildInputs = [
    git git-paf awa awa-mirage dns dns-client tls
    tls-mirage happy-eyeballs ca-certs-nss mirage-crypto ptime x509 tcpip
    domain-name fmt ipaddr lwt mirage-clock mirage-flow mirage-random
    mirage-time result rresult mimic mimic-happy-eyeballs hex

  ];

  propagatedBuildInputs = [
  ];

  checkInputs = [
    alcotest alcotest-lwt ke bigstringaf cstruct logs
  ];
  doCheck = true;

  meta = {
    description = "A package to use ocaml-git with MirageOS backend";
    inherit (git.meta) homepage license maintainers;
  };
}
