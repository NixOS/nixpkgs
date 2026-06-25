{
  lib,
  ocaml,
  version ? if lib.versionAtLeast ocaml.version "5.1" then "2.14.0" else "0.9",
  buildDunePackage,
  cstruct,
  dune-configurator,
  fetchurl,
  fmt,
  optint,
  mdx,
}:

let
  param =
    {
      "0.9" = {
        minimalOCamlVersion = "4.12";
        hash = "sha256-eXWIxfL9UsKKf4sanBjKfr6Od4fPDctVnkU+wjIXW0M=";
      };
      "2.14.0" = {
        minimalOCamlVersion = "5.1.0";
        hash = "sha256-U6B3/ExryC7WLYj1iIUHoXZQluFE56Rf3dwOpux/qIE=";
      };
    }
    .${version};
in
buildDunePackage (finalAttrs: {
  pname = "uring";
  inherit version;
  inherit (param) minimalOCamlVersion;

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/ocaml-uring/releases/download/v${finalAttrs.version}/uring-${version}.tbz";
    inherit (param) hash;
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
    homepage = "https://github.com/ocaml-multicore/ocaml-uring";
    changelog = "https://raw.githubusercontent.com/ocaml-multicore/ocaml-uring/v${finalAttrs.version}/CHANGES.md";
    description = "Bindings to io_uring for OCaml";
    license = with lib.licenses; [
      isc
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ toastal ];
  };
})
