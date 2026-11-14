{
  lib,
  fetchzip,
  buildDunePackage,
  cmdliner,
  dune-build-info,
  odoc,
  bytesrw,
  cstruct,
  eio,
  eio_main,
  fmt,
  jsont,
  matrix,
  mtime,
  re,
  alcobar,
  alcotest,
  logs,
  markup,
  mdx,
}:

buildDunePackage (finalAttrs: {
  pname = "k7";
  version = "0.9.0";

  src = fetchzip {
    url = "https://github.com/samoht/ocaml-k7/releases/download/${finalAttrs.version}/k7-${finalAttrs.version}.tbz";
    hash = "sha256-XBbRQxdsgtrLyseGf8TE4A9WCl5OWF4qt3tW+almgU0=";
  };

  minimalOCamlVersion = "5.4";

  nativeBuildInputs = [
    odoc
  ];

  buildInputs = [
    dune-build-info
  ];

  propagatedBuildInputs = [
    bytesrw
    cmdliner
    cstruct
    eio
    eio_main
    fmt
    (jsont.override { withBytesrw = true; })
    matrix
    mtime
    re
  ];

  nativeCheckInputs = [
    (mdx.override { inherit logs; })
  ];

  checkInputs = [
    alcobar
    alcotest
    markup
    (mdx.override { inherit logs; })
  ];

  # FHS in tests + timeouts
  doCheck = false;

  meta = {
    description = "Record terminal sessions and draw them as animated SVG images";
    license = lib.licenses.isc;
    homepage = "https://github.com/samoht/ocaml-k7";
    changelog = "https://raw.githubusercontent.com/samoht/ocaml-k7/refs/tags/${finalAttrs.version}/CHANGES.md";
    mainProgram = "k7";
    maintainers = with lib.maintainers; [
      toastal
    ];
    platforms = lib.filter (p: !lib.hasInfix "windows" p) lib.platforms.all;
  };
})
