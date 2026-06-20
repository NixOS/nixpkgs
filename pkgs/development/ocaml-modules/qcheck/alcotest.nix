{
  buildDunePackage,
  qcheck-core,
  alcotest,
}:

buildDunePackage {
  pname = "qcheck-alcotest";

  inherit (qcheck-core) version src;

  propagatedBuildInputs = [
    qcheck-core
    alcotest
  ];

  meta = qcheck-core.meta // {
    description = "Alcotest backend for qcheck";
  };
}
