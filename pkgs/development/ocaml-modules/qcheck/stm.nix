{ buildDunePackage
, qcheck-multicoretests-util
}:

buildDunePackage {
  pname = "qcheck-stm";

  inherit (qcheck-multicoretests-util) src version;

  propagatedBuildInputs = [ qcheck-multicoretests-util ];

  doCheck = true;

  meta = qcheck-multicoretests-util.meta // {
    description = "State-machine testing library for sequential and parallel model-based tests";
  };
}
