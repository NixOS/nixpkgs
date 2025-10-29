{
  lib,
  buildDunePackage,
  dscheck,
  multicore-magic,
}:

buildDunePackage {
  pname = "multicore-magic-dscheck";

  inherit (multicore-magic) src version;

  propagatedBuildInputs = [
    dscheck
  ];

  meta = multicore-magic.meta // {
    description = "Implementation of multicore-magic API using the atomic module of DScheck to make DScheck tests possible in libraries using multicore-magic";
  };
}
