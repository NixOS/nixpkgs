{ lib
, buildOcamlJane
, core
, core_extended
, textutils
}:

buildOcamlJane {
  pname = "core_bench";
  hash = "0000000000000000000000000000000000000000000000000000";
  propagatedBuildInputs =
    [ core core_extended textutils ];

  meta = with lib; {
    homepage = "https://github.com/janestreet/core_bench";
    description = "Micro-benchmarking library for OCaml";
    license = licenses.asl20;
    maintainers = [ maintainers.pmahoney ];
  };
}
