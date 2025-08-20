{
  buildDunePackage,
  git,
  rresult,
  bigstringaf,
  fmt,
  bos,
  fpath,
  uri,
  digestif,
  logs,
  lwt,
  mirage-clock,
  mirage-clock-unix,
  astring,
  cmdliner,
  decompress,
  domain-name,
  ipaddr,
  mtime,
  tcpip,
  mirage-flow,
  mirage-unix,
  alcotest,
  alcotest-lwt,
  base64,
  cstruct,
  ke,
  mirage-crypto-rng,
  git-binary,
  mimic,
  tls,
  cacert,
  happy-eyeballs-lwt,
  git-mirage,
}:

buildDunePackage {
  pname = "git-unix";
  inherit (git) version src;

  minimalOCamlVersion = "4.08";

  buildInputs = [
    cmdliner
    mirage-clock
    tcpip
  ];
  propagatedBuildInputs = [
    rresult
    bigstringaf
    fmt
    bos
    fpath
    digestif
    logs
    lwt
    astring
    decompress
    domain-name
    ipaddr
    mirage-flow
    mirage-unix
    cstruct
    mimic
    tls
    git
    happy-eyeballs-lwt
    git-mirage
    mirage-clock-unix
  ];
  checkInputs = [
    alcotest
    alcotest-lwt
    base64
    ke
    mirage-crypto-rng
    uri
    mtime
    cacert # sets up NIX_SSL_CERT_FILE
  ];
  nativeCheckInputs = [ git-binary ];
  doCheck = true;

  meta = {
    description = "Unix backend for the Git protocol(s)";
    inherit (git.meta) homepage license maintainers;
  };
}
