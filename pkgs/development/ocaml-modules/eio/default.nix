{ lib
, buildDunePackage
, bigstringaf
, cstruct
, domain-local-await
, dune-configurator
, fetchurl
, fmt
, hmap
, lwt-dllist
, mtime
, optint
, psq
, alcotest
, crowbar
, mdx
}:

buildDunePackage rec {
  pname = "eio";
  version = "0.10";

  minimalOCamlVersion = "5.0";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "OQ94FFB7gTPWwl46Z6dC1zHHymYlKyh7H7DjrU0Q7sw=";
  };

  propagatedBuildInputs = [
    bigstringaf
    cstruct
    domain-local-await
    fmt
    hmap
    lwt-dllist
    mtime
    optint
    psq
  ];

  checkInputs = [
    alcotest
    crowbar
    mdx
  ];

  nativeCheckInputs = [
    mdx.bin
  ];

  meta = {
    homepage = "https://github.com/ocaml-multicore/ocaml-${pname}";
    changelog = "https://github.com/ocaml-multicore/ocaml-${pname}/raw/v${version}/CHANGES.md";
    description = "Effects-Based Parallel IO for OCaml";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ toastal ];
  };
}
