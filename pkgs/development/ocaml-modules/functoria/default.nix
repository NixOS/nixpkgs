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

  doCheck = true;
  checkInputs = [
    alcotest
    functoria-runtime
  ];

  meta = with lib; {
    description = "A DSL to organize functor applications";
    homepage = "https://github.com/mirage/functoria";
    license = licenses.isc;
    maintainers = [ maintainers.vbgl ];
  };
}
