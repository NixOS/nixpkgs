{
  alcobar,
  buildDunePackage,
  bytesrw,
  cmdliner,
  dune-build-info,
  fetchFromGitHub,
  fmt,
  lib,
  logs,
  markup,
  mdx,
  mtime,
  psq,
  python3,
  uri,
}:

buildDunePackage (finalAttrs: {
  pname = "cascade";
  version = "1.2.1";
  minimalOCamlVersion = "5.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "samoht";
    repo = "cascade";
    tag = finalAttrs.version;
    hash = "sha256-rjuySiVqOq6Ywrozkt2mNaWyXQkXuSynBj8ebv9TLpE=";
  };

  propagatedBuildInputs = [
    dune-build-info
    fmt
    logs
    markup
    mtime
    psq
    uri
  ];
  buildInputs = [
    cmdliner
  ];

  nativeCheckInputs = [
    mdx.out
    python3
  ];
  checkInputs = [
    (mdx.override { inherit logs; })
    alcobar
    bytesrw
  ];
  # Some checks fail: linking error related to bytesrw
  doCheck = false;

  meta = {
    description = "CSS generation and manipulation library for OCaml";
    homepage = "https://github.com/samoht/cascade";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vog ];
  };
})
