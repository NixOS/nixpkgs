{ buildDunePackage
, alcotest, cmdliner, irmin, metrics-unix, mtime, irmin-layers
}:

buildDunePackage {

  pname = "irmin-test";

  inherit (irmin) version src;

  useDune2 = true;

  propagatedBuildInputs = [
    alcotest cmdliner irmin metrics-unix mtime irmin-layers
  ];

  meta = irmin.meta // {
    description = "Irmin test suite";
  };

}
