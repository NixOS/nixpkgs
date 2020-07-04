{ lib, buildDunePackage, fetchurl, ipaddr, functoria-runtime
, fmt, logs, ocaml_lwt, alcotest }:

buildDunePackage rec {
  pname = "mirage-runtime";
  version = "3.8.0";

  minimumOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/mirage/mirage/releases/download/v${version}/mirage-v${version}.tbz";
    sha256 = "18v37arzy7gkz5qcy34k0l8g69146nysjv0h1jcym0h4xxy0bxir";
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
