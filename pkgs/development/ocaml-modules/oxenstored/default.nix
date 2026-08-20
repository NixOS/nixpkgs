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

  # The xen package builds both plugin_interface_v1 (the xsd_glue library)
  # and domain_getinfo_v1.cmxs (the plugin) together, ensuring they share
  # the same .cmi hashes. If we don't use the xen package's interface
  # and plugin, oxenstored will refuse to dynamically load it, given
  # the different interface hashes and build environments (make vs dune,
  # lead to different file hashes), the dynamic load refuses to load the
  # library from the xen package altogether.
  # This removes oxenstored's local copy of xsd_glue and instead uses
  # xen's pre-compiled version found via OCAMLPATH to make sure everything
  # is consistent and xenstored is built with the same plugin & interface
  # as the xen package, allowing the plugin to load and interface with
  # the xen package's libraries.
  postPatch = ''
    rm -rf xsd_glue
  '';

  doCheck = true;

  meta = {
    description = "OCaml implementation of Xenstore";
    longDescription = ''
      Formerly developed in the monolithic Xen repository, `oxenstored` was
      forked during the development cycle of Xen 4.20 and is now built separately.

      Uses the `xsd_glue` plugin interface from the `xen` package to ensure ABI
      compatibility with Xen's `domain_getinfo_v1` plugin.
    '';
    license = lib.licenses.lgpl21Only;
    teams = [ lib.teams.xen ];
    homepage = "https://github.com/xapi-project/oxenstored";
  };
})
