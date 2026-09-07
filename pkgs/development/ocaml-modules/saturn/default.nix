{
  lib,
  fetchurl,
  ocaml,
  version ? "1.0.0",
  buildDunePackage,
  backoff,
  domain_shims,
  dscheck,
  mdx,
  multicore-bench,
  multicore-magic,
  multicore-magic-dscheck,
  qcheck,
  qcheck-alcotest,
  qcheck-stm,
}:

buildDunePackage {
  inherit version;

  pname = "saturn";

  minimalOCamlVersion = "4.14";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/saturn/releases/download/${version}/saturn-${version}.tbz";
    sha512 = "925104a4293326d345701e80932ace2b5d2da02ca6406271d33cd54f9e9c6583f35b060bc42c640357c98669f5bc42e8447dbd21614ae02ce5b5efaa8f04a132";
  };

  propagatedBuildInputs = [
    backoff
    multicore-magic
  ];

  doCheck = lib.versionAtLeast ocaml.version "5.2";
  checkInputs = [
    domain_shims
    dscheck
    mdx
    multicore-bench
    multicore-magic-dscheck
    qcheck
    qcheck-alcotest
    qcheck-stm
  ];
  nativeCheckInputs = [ mdx.bin ];

  meta = {
    description = "Parallelism-safe data structures for multicore OCaml";
    homepage = "https://github.com/ocaml-multicore/lockfree";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
