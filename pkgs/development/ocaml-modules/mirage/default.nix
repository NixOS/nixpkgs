{
  buildDunePackage,
  ocaml,
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

buildDunePackage rec {
  pname = "mirage";
  inherit (mirage-runtime) version src;

  minimalOCamlVersion = "4.13";

  outputs = [
    "out"
    "dev"
  ];

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

  installPhase = ''
    runHook preInstall
    dune install --prefix=$out --libdir=$dev/lib/ocaml/${ocaml.version}/site-lib/ ${pname}
    runHook postInstall
  '';

  meta = mirage-runtime.meta // {
    description = "MirageOS library operating system";
  };
}
