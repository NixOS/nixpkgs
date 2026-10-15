{
  lib,
  ocaml,
  version ?
    if lib.versionAtLeast ocaml.version "5.2" then
      "2.15.0"
    else if lib.versionAtLeast ocaml.version "5.1" then
      "2.14.0"
    else
      "0.9",
  fetchurl,
  pkg-config,
  buildDunePackage,
  cstruct,
  dune-configurator,
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
      "2.15.0" = {
        minimalOCamlVersion = "5.2.0";
        hash = "sha256-MK1F5tTbvZT5MkyZrz28+nj4+Yo8VxdxCBDHghUdMYY=";
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

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dune-configurator
  ];

  propagatedBuildInputs = [
    cstruct
    fmt
    optint
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
