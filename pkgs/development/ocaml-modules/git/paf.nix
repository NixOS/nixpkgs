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
  rresult,
  tls,
  uri,
  bigstringaf,
  domain-name,
  h1,
  mirage-flow,
  tls-mirage,
}:

buildDunePackage {
  pname = "git-paf";

  inherit (git) version src;

  postPatch = ''
    substituteInPlace src/git-paf/dune --replace-fail bigstringaf 'bigstringaf bstr'
    substituteInPlace src/git-paf/git_paf.ml --replace-fail Bigstringaf.t Bstr.t
  '';

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
    tls
    uri
    bigstringaf
    domain-name
    h1
    mirage-flow
    tls-mirage
  ];

  meta = git.meta // {
    description = "Package to use HTTP-based ocaml-git with MirageOS backend";
  };
}
