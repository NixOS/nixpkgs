{ lib, buildDunePackage, fetchurl, ipaddr, functoria-runtime
, fmt, logs, ocaml_lwt, alcotest }:

buildDunePackage rec {
  pname = "mirage-runtime";
  version = "3.10.7";

  useDune2 = true;

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/mirage/releases/download/v${version}/mirage-v${version}.tbz";
    sha256 = "fec4492239c6d1fdd73db4da0782e33e66202e19595bf1d52aa98972296cc72d";
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
