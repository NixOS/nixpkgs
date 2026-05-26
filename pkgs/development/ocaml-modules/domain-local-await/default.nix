{
  lib,
  ocaml,
  buildDunePackage,
  fetchurl,
  alcotest,
  domain_shims,
  mdx,
  thread-table,
}:

buildDunePackage (finalAttrs: {
  pname = "domain-local-await";
  version = "1.0.1";

  minimalOCamlVersion = "5.0";

  # Fix build with gcc15
  env = lib.optionalAttrs (lib.versions.majorMinor ocaml.version == "5.0") {
    NIX_CFLAGS_COMPILE = "-std=gnu11";
  };

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/domain-local-await/releases/download/${finalAttrs.version}/domain-local-await-${finalAttrs.version}.tbz";
    hash = "sha256-KVIRPFPLB+KwVLLchs5yk5Ex2rggfI8xOa2yPmTN+m8=";
  };

  propagatedBuildInputs = [
    thread-table
  ];

  __darwinAllowLocalNetworking = true;
  doCheck = true;

  checkInputs = [
    alcotest
    domain_shims
    mdx
  ];

  nativeCheckInputs = [
    mdx.bin
  ];

  meta = {
    homepage = "https://github.com/ocaml-multicore/ocaml-domain-local-await";
    changelog = "https://github.com/ocaml-multicore/ocaml-domain-local-await/raw/v${finalAttrs.version}/CHANGES.md";
    description = "Scheduler independent blocking mechanism";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ toastal ];
  };
})
