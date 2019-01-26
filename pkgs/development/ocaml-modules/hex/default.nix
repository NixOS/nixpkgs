{ stdenv, fetchurl, buildDunePackage, cstruct }:

buildDunePackage rec {
  pname = "hex";
  version = "1.2.0";

  minimumOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-${pname}/releases/download/v${version}/hex-${version}.tbz";
    sha256 = "17hqf7z5afp2z2c55fk5myxkm7cm74259rqm94hcxkqlpdaqhm8h";
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
