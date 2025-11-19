{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-site,
  fmt,
  alcotest,
  xen,
}:

buildDunePackage (finalAttrs: {
  pname = "oxenstored";
  version = "25.3.0";

  src = fetchFromGitHub {
    owner = "xapi-project";
    repo = "oxenstored";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+JXgVO6m63sPzVTwpq/ztDBx/x/g5vtU1Xbcd+t5ons=";
  };

  buildInputs = [
    dune-site
    fmt
    xen
  ];
  checkInputs = [
    alcotest
  ];

  doCheck = true;

  env = {
    XEN_CONFIG_DIR = "${xen}/etc/xen";
    LIBEXEC = "${xen}/libexec/xen";
  };

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
