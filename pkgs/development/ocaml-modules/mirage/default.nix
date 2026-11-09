{
  buildDunePackage,
  mirage-runtime,
  astring,
  bos,
  cmdliner,
  emile,
  fmt,
  fpath,
  ipaddr,
  logs,
  rresult,
  uri,
}:

buildDunePackage (finalAttrs: {
  pname = "mirage";
  inherit (mirage-runtime) version src;

  minimalOCamlVersion = "4.13";

  propagatedBuildInputs = [
    astring
    bos
    cmdliner
    emile
    fmt
    fpath
    ipaddr
    logs
    rresult
    uri
  ];

  # Tests need opam-monorepo
  doCheck = false;

  meta = mirage-runtime.meta // {
    description = "MirageOS library operating system";
  };
})
