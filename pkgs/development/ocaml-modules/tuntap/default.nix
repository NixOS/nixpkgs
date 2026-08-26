{
  lib,
  buildDunePackage,
  fetchurl,
  ipaddr,
  macaddr,
}:

buildDunePackage (finalAttrs: {
  pname = "tuntap";
  version = "2.0.2";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-tuntap/releases/download/v${finalAttrs.version}/tuntap-${finalAttrs.version}.tbz";
    hash = "sha256-DfztWPkNhdSIX/TaldCoNhAA/AZwQDqCdRmDOyOORu0=";
  };

  propagatedBuildInputs = [
    ipaddr
    macaddr
  ];

  # tests manipulate network devices and use network
  # also depend on LWT 5
  doCheck = false;

  meta = {
    description = "Bindings to the UNIX tuntap facility";
    homepage = "https://github.com/mirage/ocaml-tuntap";
    license = lib.licenses.isc;
  };
})
