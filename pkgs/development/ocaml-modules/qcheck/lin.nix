{ buildDunePackage
, qcheck-multicoretests-util
}:

buildDunePackage {
  pname = "qcheck-lin";

  inherit (qcheck-multicoretests-util) version src;

  propagatedBuildInputs = [ qcheck-multicoretests-util ];

  doCheck = true;

  meta = qcheck-multicoretests-util.meta // {
    description = "A multicore testing library for OCaml";
  };
}
