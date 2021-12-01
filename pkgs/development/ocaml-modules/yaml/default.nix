{ lib, fetchurl, buildDunePackage
, dune-configurator
, bos, ctypes, fmt, logs, rresult
, mdx, alcotest, crowbar, junit_alcotest, ezjsonm
}:

buildDunePackage rec {
  pname = "yaml";
  version = "3.0.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/avsm/ocaml-yaml/releases/download/v${version}/yaml-v${version}.tbz";
    sha256 = "1iws6lbnrrd5hhmm7lczfvqp0aidx5xn7jlqk2s5rjfmj9qf4j2c";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ bos ctypes rresult ];
  checkInputs = [ fmt logs mdx alcotest crowbar junit_alcotest ezjsonm ];

  meta = {
    description = "Parse and generate YAML 1.1 files";
    homepage = "https://github.com/avsm/ocaml-yaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
