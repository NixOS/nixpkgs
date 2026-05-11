{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  qcheck,
  ppxlib,
  ppx_deriving,
}:

let
  param =
    if lib.versionAtLeast ppxlib.version "0.36" then
      {
        version = "0.9";
        tag = "v0.91";
        hash = "sha256-ToF+bRbiq1P5YaGOKiW//onJDhxaxmnaz9/JbJ82OWM=";
      }
    else
      {
        version = "0.6";
        tag = "v0.24";
        hash = "sha256-iuFlmSeUhumeWhqHlaNqDjReRf8c4e76hhT27DK3+/g=";
      };
in

buildDunePackage {
  pname = "ppx_deriving_qcheck";
  inherit (param) version;

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "qcheck";
    inherit (param) tag hash;
  };

  propagatedBuildInputs = [
    qcheck
    ppxlib
    ppx_deriving
  ];

  meta = qcheck.meta // {
    description = "PPX Deriver for QCheck";
  };
}
