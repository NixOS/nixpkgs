{
  lib,
  buildDunePackage,
  cmdliner,
  functoria-runtime,
  rresult,
  astring,
  fmt,
  logs,
  bos,
  fpath,
  emile,
  uri,
  alcotest,
}:

buildDunePackage {
  pname = "functoria";
  inherit (functoria-runtime) version src;

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    cmdliner
    rresult
    astring
    fmt
    logs
    bos
    fpath
    emile
    uri
  ];

  # Tests are not compatible with cmdliner 1.3
  doCheck = false;
  checkInputs = [
    alcotest
    functoria-runtime
  ];

  meta = {
    description = "DSL to organize functor applications";
    homepage = "https://github.com/mirage/functoria";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
