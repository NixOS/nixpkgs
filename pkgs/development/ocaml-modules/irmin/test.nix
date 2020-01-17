{ buildDunePackage, alcotest, cmdliner, irmin, metrics-unix, mtime }:

buildDunePackage {

  pname = "irmin-test";

  inherit (irmin) version src;

  propagatedBuildInputs = [ alcotest cmdliner irmin metrics-unix mtime ];

  meta = irmin.meta // {
    description = "Irmin test suite";
  };

}
