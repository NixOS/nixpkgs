{ stdenv, fetchurl, buildDunePackage, cstruct }:

buildDunePackage rec {
  pname = "hex";
  version = "1.3.0";

  minimumOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-${pname}/releases/download/v${version}/hex-v${version}.tbz";
    sha256 = "193567pn58df3b824vmfanncdfgf9cxzl7q3rq39zl9szvzhvkja";
  };

  propagatedBuildInputs = [ cstruct ];
  doCheck = true;

  meta = {
    description = "Mininal OCaml library providing hexadecimal converters";
    homepage = https://github.com/mirage/ocaml-hex;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
