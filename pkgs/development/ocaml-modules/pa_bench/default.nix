{stdenv, buildOcaml, fetchurl, type_conv, pa_ounit}:

buildOcaml rec {
  name = "pa_bench";
  version = "112.06.00";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchurl {
    url = "https://github.com/janestreet/pa_bench/archive/${version}.tar.gz";
    sha256 = "e3401e37f1d3d4acb957fd46a192d0ffcefeb0bedee63bbeb26969af1d540870";
  };

  buildInputs = [ pa_ounit ];
  propagatedBuildInputs = [ type_conv ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/pa_bench;
    description = "Syntax extension for inline benchmarks";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
