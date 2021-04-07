{ lib, fetchurl, buildDunePackage
, dune-configurator
, ppx_sexp_conv
, bos, ctypes, fmt, logs, rresult, sexplib
}:

buildDunePackage rec {
  pname = "yaml";
  version = "2.1.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/avsm/ocaml-yaml/releases/download/v${version}/yaml-v${version}.tbz";
    sha256 = "03g8vsh5jgi1cm5q78v15slgnzifp91fp7n4v1i7pa8yk0bkh585";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ bos ctypes fmt logs ppx_sexp_conv rresult sexplib ];

  meta = {
    description = "Parse and generate YAML 1.1 files";
    homepage = "https://github.com/avsm/ocaml-yaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
