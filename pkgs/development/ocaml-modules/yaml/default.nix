{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv
, bos, ctypes, fmt, logs, rresult, sexplib
}:

buildDunePackage rec {
  pname = "yaml";
  version = "2.0.1";

  src = fetchurl {
    url = "https://github.com/avsm/ocaml-yaml/releases/download/v${version}/yaml-v${version}.tbz";
    sha256 = "1r8jj572h416g2zliwmxj2j9hkv73nxnpfb9gmbj9gixg24lskx0";
  };

  propagatedBuildInputs = [ bos ctypes fmt logs ppx_sexp_conv rresult sexplib ];

  meta = {
    description = "Parse and generate YAML 1.1 files";
    homepage = "https://github.com/avsm/ocaml-yaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
