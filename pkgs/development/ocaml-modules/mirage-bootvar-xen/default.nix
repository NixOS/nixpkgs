{ lib
, buildDunePackage
, fetchurl
, mirage-xen
, parse-argv
, lwt
}:

buildDunePackage rec {
  pname = "mirage-bootvar-xen";
  version = "0.8.0";

  minimumOCamlVersion = "4.08";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-bootvar-xen/releases/download/v${version}/mirage-bootvar-xen-v${version}.tbz";
    sha256 = "0nk80giq9ng3svbnm68fjby2f1dnarddm3lk7mw7w59av71q0rcv";
  };

  propagatedBuildInputs = [
    mirage-xen
    lwt
    parse-argv
  ];

  meta = with lib; {
    description = "Handle boot-time arguments for Xen platform";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    homepage = "https://github.com/mirage/mirage-bootvar-xen";
  };
}
