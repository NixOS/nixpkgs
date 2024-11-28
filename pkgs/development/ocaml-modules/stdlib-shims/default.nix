{ buildDunePackage, lib, fetchurl, ocaml }:

buildDunePackage rec {
  pname = "stdlib-shims";
  version = "0.3.0";
  src = fetchurl {
    url = "https://github.com/ocaml/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "0jnqsv6pqp5b5g7lcjwgd75zqqvcwcl5a32zi03zg1kvj79p5gxs";
  };
  doCheck = true;
  meta = {
    description = "Shims for forward-compatibility between versions of the OCaml standard library";
    homepage = "https://github.com/ocaml/stdlib-shims";
    inherit (ocaml.meta) license;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
