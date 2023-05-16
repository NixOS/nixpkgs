{ lib
, buildDunePackage
, cstruct
, dune-configurator
, fetchurl
, fmt
, optint
, mdx
}:

buildDunePackage rec {
  pname = "uring";
<<<<<<< HEAD
  version = "0.7";

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/ocaml-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "khxV8aZYvdqYGjb1a27JQ+K8yg7OJN4ziJT2hzNIFQM=";
=======
  version = "0.5";

  minimalOCamlVersion = "4.12";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/ocaml-uring/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "106w7mabqihdhj4csk9jfqag220rwhqdp5lapn0xmw2035scvxvk";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    cstruct
    fmt
    optint
  ];

  buildInputs = [
    dune-configurator
  ];

  checkInputs = [
    mdx
  ];

  nativeCheckInputs = [
    mdx.bin
  ];

  doCheck = true;

  dontStrip = true;

  meta = {
    homepage = "https://github.com/ocaml-multicore/ocaml-${pname}";
    changelog = "https://github.com/ocaml-multicore/ocaml-${pname}/raw/v${version}/CHANGES.md";
    description = "Bindings to io_uring for OCaml";
    license = with lib.licenses; [ isc mit ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ toastal ];
  };
}
