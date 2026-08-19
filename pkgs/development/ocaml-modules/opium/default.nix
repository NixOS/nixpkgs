{
  buildDunePackage,
  lib,
  astring,
  base64,
  cmdliner,
  fmt,
  httpaf,
  httpaf-lwt-unix,
  logs,
  magic-mime,
  mirage-crypto,
  mtime,
  multipart-form-data,
  ptime,
  re,
  rock,
  tyxml,
  uri,
  yojson,
  alcotest-lwt,
}:

buildDunePackage {
  pname = "opium";
  minimalOCamlVersion = "4.08";

  inherit (rock) src version;

  propagatedBuildInputs = [
    astring
    base64
    cmdliner
    fmt
    httpaf
    httpaf-lwt-unix
    logs
    magic-mime
    mirage-crypto
    mtime
    multipart-form-data
    ptime
    re
    rock
    tyxml
    uri
    yojson
  ];

  doCheck = true;
  checkInputs = [
    alcotest-lwt
  ];

  meta = {
    description = "OCaml web framework";
    homepage = "https://github.com/rgrinberg/opium";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pmahoney ];
    broken = true; # Not compatible with mirage-crypto ≥ 1.0
  };
}
