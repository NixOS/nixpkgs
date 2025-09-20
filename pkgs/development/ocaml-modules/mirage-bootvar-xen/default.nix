{
  lib,
  buildDunePackage,
  fetchurl,
  mirage-xen,
  parse-argv,
  lwt,
}:

buildDunePackage rec {
  pname = "mirage-bootvar-xen";
  version = "0.8.0";

  minimalOCamlVersion = "4.08";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-bootvar-xen/releases/download/v${version}/mirage-bootvar-xen-v${version}.tbz";
    hash = "sha256:0nk80giq9ng3svbnm68fjby2f1dnarddm3lk7mw7w59av71q0rcv";
  };

  propagatedBuildInputs = [
    mirage-xen
    lwt
    parse-argv
  ];

  meta = {
    description = "Handle boot-time arguments for Xen platform";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.sternenseemann ];
    homepage = "https://github.com/mirage/mirage-bootvar-xen";
  };
}
