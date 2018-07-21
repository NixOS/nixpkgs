{stdenv, atd, yojson, biniou, buildOcaml, fetchurl, which}:

buildOcaml rec {
  name = "atdgen";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/mjambon/atdgen/archive/v${version}.tar.gz";
    sha256 = "1icdxgb7qqq1pcbfqi0ikryiwaljd594z3acyci8g3bnlq0yc7zn";
  };

  installPhase = ''
    mkdir -p $out/bin
    make PREFIX=$out install
  '';

  buildInputs = [ which atd biniou yojson ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mjambon/atdgen;
    description = "Generates optimized boilerplate OCaml code for JSON and Biniou IO from type definitions";
    license = licenses.bsd3;
    maintainers = [ maintainers.jwilberding ];
  };
}
