{
  lib,
  buildDunePackage,
  fetchurl,
  ipaddr,
  macaddr,
}:

buildDunePackage (finalAttrs: {
  pname = "tuntap";
  version = "2.0.1";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-tuntap/releases/download/v${finalAttrs.version}/tuntap-${finalAttrs.version}.tbz";
    hash = "sha256-J8YBl8w7xFloDqt/Xiz03KCIls5BR72VT8X/LYZMDN0=";
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
