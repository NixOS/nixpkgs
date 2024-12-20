{
  lib,
  buildDunePackage,
  cstruct,
  dune-configurator,
  fetchurl,
  fmt,
  optint,
  mdx,
}:

buildDunePackage rec {
  pname = "uring";
  version = "0.9";

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/ocaml-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-eXWIxfL9UsKKf4sanBjKfr6Od4fPDctVnkU+wjIXW0M=";
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

  # Tests use io_uring, which is blocked by Lix's sandbox because it's
  # opaque to seccomp.
  doCheck = false;

  dontStrip = true;

  meta = {
    homepage = "https://github.com/ocaml-multicore/ocaml-${pname}";
    changelog = "https://github.com/ocaml-multicore/ocaml-${pname}/raw/v${version}/CHANGES.md";
    description = "Bindings to io_uring for OCaml";
    license = with lib.licenses; [
      isc
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ toastal ];
  };
}
