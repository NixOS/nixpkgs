{ lib, fetchurl, buildDunePackage
, dune-configurator
, bos, ctypes, fmt, logs
, mdx, alcotest, crowbar, junit_alcotest, ezjsonm
}:

buildDunePackage rec {
  pname = "yaml";
  version = "3.1.0";

  src = fetchurl {
    url = "https://github.com/avsm/ocaml-yaml/releases/download/v${version}/yaml-${version}.tbz";
    sha256 = "sha256-0KngriGEpp5tcgK/43B9EEOdMacSQYYCNLGfAgRS7Mc=";
  };

  minimalOCamlVersion = "4.13";

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ bos ctypes ];

  doCheck = true;
  checkInputs = [ fmt logs mdx.bin alcotest crowbar junit_alcotest ezjsonm ];

  meta = {
    description = "Parse and generate YAML 1.1 files";
    homepage = "https://github.com/avsm/ocaml-yaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
