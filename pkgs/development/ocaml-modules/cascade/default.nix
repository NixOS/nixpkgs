{
  alcobar,
  buildDunePackage,
  dune-build-info,
  fetchFromGitHub,
  lambdasoup,
  lib,
  logs,
  mdx,
  psq,
  uri,
  uutf,
}:

buildDunePackage (finalAttrs: {
  pname = "cascade";
  version = "1.1.0";
  minimalOCamlVersion = "5.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "samoht";
    repo = "cascade";
    tag = finalAttrs.version;
    hash = "sha256-JxlD8wVqbc3tuT/Utwy8K2kEXtf6aeWPMVA246e6lLw=";
  };

  propagatedBuildInputs = [
    dune-build-info
    logs
    psq
    uri
    uutf
  ];
  buildInputs = [
    lambdasoup
  ];

  nativeCheckInputs = [ mdx.out ];
  checkInputs = [
    (mdx.override { inherit logs; })
    alcobar
  ];
  doCheck = true;

  meta = {
    description = "CSS generation and manipulation library for OCaml";
    homepage = "https://github.com/samoht/cascade";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vog ];
  };
})
