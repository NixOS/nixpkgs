{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildDunePackage,
  lwt,
  ppxlib,
}:

buildDunePackage {
  pname = "lwt_ppx";
  inherit (lwt) version src;

  patches = lib.optional (lib.versionAtLeast ppxlib.version "0.36") (fetchpatch {
    url = "https://github.com/ocsigen/lwt/commit/96b7ac686208968503786bb6d101f4ee84c8d2e6.patch";
    hash = "sha256-uxTwNVqV0O11WEKy66fphvGqW17FWDEzEylhVYNwNnY=";
  });

  propagatedBuildInputs = [
    lwt
    ppxlib
  ];

  meta = {
    description = "Ppx syntax extension for Lwt";
    inherit (lwt.meta) license homepage maintainers;
  };
}
