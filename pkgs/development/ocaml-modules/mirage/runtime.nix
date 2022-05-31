{ lib, buildDunePackage, fetchurl, ipaddr, functoria-runtime
, fmt, logs, lwt, alcotest }:

buildDunePackage rec {
  pname = "mirage-runtime";
  version = "4.1.1";

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/mirage/releases/download/v${version}/mirage-${version}.tbz";
    sha256 = "sha256-Os5Mj9MybpWg8rfrerB7HZ82433hsAZsrifTa0/FhxU=";
  };

  propagatedBuildInputs = [ ipaddr functoria-runtime fmt logs lwt ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage";
    description = "The base MirageOS runtime library, part of every MirageOS unikernel";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
