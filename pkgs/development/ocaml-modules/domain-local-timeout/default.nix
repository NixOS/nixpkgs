{
  lib,
  buildDunePackage,
  ocaml,
  fetchurl,
  mtime,
  psq,
  thread-table,
  alcotest,
  mdx,
  domain-local-await,
}:

buildDunePackage rec {
  pname = "domain-local-timeout";
  version = "1.0.1";

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/domain-local-timeout/releases/download/${version}/domain-local-timeout-${version}.tbz";
    hash = "sha256-6sCqUkOjN8E+7OLUwVQntkv0vrQDkGDV8KNqDhVm0d8=";
  };

  propagatedBuildInputs = [
    mtime
    psq
    thread-table
  ];

  doCheck = lib.versionAtLeast ocaml.version "5.0";
  nativeCheckInputs = [ mdx.bin ];
  checkInputs = [
    alcotest
    domain-local-await
    mdx
  ];

  meta = {
    homepage = "https://github.com/ocaml-multicore/domain-local-timeout";
    description = "Scheduler independent timeout mechanism";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
