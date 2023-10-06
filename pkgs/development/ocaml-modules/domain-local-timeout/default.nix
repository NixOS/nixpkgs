{ lib, buildDunePackage, ocaml, fetchurl
, mtime, psq, thread-table
, alcotest, mdx
, domain-local-await
}:

buildDunePackage rec {
  pname = "domain-local-timeout";
  version = "0.1.0";

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/domain-local-timeout/releases/download/${version}/domain-local-timeout-${version}.tbz";
    hash = "sha256-UTqcHdGAN/LrvumPhW4Cy6RY8RJ/iVO5zTJKrhPRTjk=";
  };

  propagatedBuildInputs = [ mtime psq thread-table ];

  doCheck = lib.versionAtLeast ocaml.version "5.0";
  nativeCheckInputs = [ mdx.bin ];
  checkInputs = [ alcotest domain-local-await mdx ];

  meta = {
    homepage = "https://github.com/ocaml-multicore/domain-local-timeout";
    description = "A scheduler independent timeout mechanism";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
