{ lib
, ocaml
, version ? if lib.versionAtLeast ocaml.version "5.1" then "1.1" else "0.12"
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

let
  param = {
    "0.12" = {
      minimalOCamlVersion = "5.0";
      hash = "sha256-2EhHzoX/t4ZBSWrSS+PGq1zCxohc7a1q4lfsrFnZJqA=";
    };
    "1.1" = {
      minimalOCamlVersion = "5.1";
      hash = "sha256-NGEEiEB38UCzV04drMwCISlgxu/reTyAPj5ri6/qD6s=";
    };
  }."${version}";
in
buildDunePackage rec {
  pname = "eio";
  inherit version;
  inherit (param) minimalOCamlVersion;

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    inherit (param) hash;
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
    homepage = "https://github.com/ocaml-multicore/${pname}";
    changelog = "https://github.com/ocaml-multicore/${pname}/raw/v${version}/CHANGES.md";
    description = "Effects-Based Parallel IO for OCaml";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ toastal ];
  };
}
