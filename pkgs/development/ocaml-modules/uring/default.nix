{ lib
, buildDunePackage
, cstruct
, dune-configurator
, fetchurl
, fetchpatch
, fmt
, optint
, mdx
}:

buildDunePackage rec {
  pname = "uring";
  version = "0.8";

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/ocaml-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-4OGst19vqEzuNVxO5xxtzS+mEilEBFoEc7lC3j3sTk4=";
  };

  patches = [
    (fetchpatch {
      name = "musl-1.2.5.patch";
      url = "https://github.com/ocaml-multicore/ocaml-uring/commit/abe340086574c124061434054937d1f19ee6bb71.patch";
      hash = "sha256-J4ZQAdQZ9fhT3/vAh5FYMyvMllTowe4GyHJy5RGUTv0=";
    })
  ];

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
