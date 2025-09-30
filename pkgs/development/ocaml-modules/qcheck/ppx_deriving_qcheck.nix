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
        version = "0.7";
        tag = "v0.25";
        hash = "sha256-Z89jJ21zm89wb9m5HthnbHdnE9iXLyaH9k8S+FAWkKQ=";
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
