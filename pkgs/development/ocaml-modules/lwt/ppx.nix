{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  lwt,
  ppxlib,
}:

buildDunePackage {
  pname = "lwt_ppx";
  inherit (lwt) version src;

  propagatedBuildInputs = [
    lwt
    ppxlib
  ];

  meta = {
    description = "Ppx syntax extension for Lwt";
    inherit (lwt.meta) license homepage maintainers;
  };
}
