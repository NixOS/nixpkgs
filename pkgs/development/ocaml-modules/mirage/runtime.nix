{ lib, buildDunePackage, fetchurl, ipaddr, functoria-runtime
, fmt, logs, ocaml_lwt, alcotest }:

buildDunePackage rec {
  pname = "mirage-runtime";
  version = "3.10.3";

  useDune2 = true;

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/mirage/releases/download/v${version}/mirage-v${version}.tbz";
    sha256 = "7c8059ef9e330eaef1ed51c0d89afe17900310f8083a426cd8099602222c2281";
  };

  propagatedBuildInputs = [ ipaddr functoria-runtime fmt logs ocaml_lwt ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage";
    description = "The base MirageOS runtime library, part of every MirageOS unikernel";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
