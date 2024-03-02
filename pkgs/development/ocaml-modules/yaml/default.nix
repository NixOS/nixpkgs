{ lib, fetchurl, buildDunePackage
, dune-configurator
, bos, ctypes, fmt, logs
, mdx, alcotest, crowbar, junit_alcotest, ezjsonm
}:

buildDunePackage rec {
  pname = "yaml";
  version = "3.2.0";

  src = fetchurl {
    url = "https://github.com/avsm/ocaml-yaml/releases/download/v${version}/yaml-${version}.tbz";
    hash = "sha256-xQ0qyii5+WZ5K3HhYDNR5dJO2k39PkRT+9UDZqOggic=";
  };

  minimalOCamlVersion = "4.13";

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ bos ctypes ];

  doCheck = true;
  nativeCheckInputs = [ mdx.bin ];
  checkInputs = [ fmt logs alcotest crowbar junit_alcotest ezjsonm ];

  meta = {
    description = "Parse and generate YAML 1.1 files";
    homepage = "https://github.com/avsm/ocaml-yaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
