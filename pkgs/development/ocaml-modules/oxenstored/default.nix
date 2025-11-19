{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  replaceVars,
  dune-site,
  fmt,
  xen,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "oxenstored";
  version = "25.3.0";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "xapi-project";
    repo = "oxenstored";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+JXgVO6m63sPzVTwpq/ztDBx/x/g5vtU1Xbcd+t5ons=";
  };

  patches = [ (replaceVars ./xen-paths.patch { inherit xen; }) ];

  buildInputs = [
    dune-site
    fmt
    xen
  ];

  checkInputs = [
    alcotest
  ];

  doCheck = true;

  meta = {
    description = "OCaml implementation of Xenstore";
    longDescription = ''
      Formerly developed in the monolithic Xen repository, `oxenstored` was
      forked during the development cycle of Xen 4.20 and is now built separately.
    '';
    license = lib.licenses.lgpl21Only;
    teams = [ lib.teams.xen ];
    homepage = "https://github.com/xapi-project/oxenstored";
  };
})
