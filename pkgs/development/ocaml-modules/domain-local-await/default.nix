{
  lib,
  buildDunePackage,
  fetchurl,
  alcotest,
  domain_shims,
  mdx,
  thread-table,
}:

buildDunePackage rec {
  pname = "domain-local-await";
  version = "1.0.1";

  minimalOCamlVersion = "5.0";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    hash = "sha256-KVIRPFPLB+KwVLLchs5yk5Ex2rggfI8xOa2yPmTN+m8=";
  };

  propagatedBuildInputs = [
    thread-table
  ];

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
    homepage = "https://github.com/ocaml-multicore/ocaml-${pname}";
    changelog = "https://github.com/ocaml-multicore/ocaml-${pname}/raw/v${version}/CHANGES.md";
    description = "Scheduler independent blocking mechanism";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ toastal ];
  };
}
