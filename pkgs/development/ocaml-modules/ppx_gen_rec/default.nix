{ stdenv, fetchurl, buildDunePackage, ocaml-migrate-parsetree }:

buildDunePackage rec {
  pname = "ppx_gen_rec";
  version = "1.1.0";

  minimumOCamlVersion = "4.01";

  src = fetchurl {
    url = "https://github.com/flowtype/ocaml-${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "0fwi4bknq8h9zgpsarjvnzdm9bm8qlyyw0lz30pihg02aiiljqbh";
  };

  buildInputs = [ ocaml-migrate-parsetree ];

  meta = with stdenv.lib; {
    homepage = https://github.com/flowtype/ocaml-ppx_gen_rec;
    description = "ocaml preprocessor that generates a recursive module";
    license = licenses.mit;
    maintainers = [ maintainers.frontsideair ];
  };
}
