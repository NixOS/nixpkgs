{ buildDunePackage
, alcotest, cmdliner_1_1, irmin, metrics-unix, mtime
}:

buildDunePackage {

  pname = "irmin-test";

  inherit (irmin) version src;

  useDune2 = true;

  propagatedBuildInputs = [
    alcotest cmdliner_1_1 irmin metrics-unix mtime
  ];

  meta = irmin.meta // {
    description = "Irmin test suite";
  };

}
