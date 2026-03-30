{
  buildDunePackage,
  lib,
  ocaml,
  junit,
  alcotest,
}:

buildDunePackage {
  pname = "junit_alcotest";

  inherit (junit) src version meta;

  propagatedBuildInputs = [
    junit
    alcotest
  ];

  doCheck = lib.versionAtLeast ocaml.version "4.12";
}
