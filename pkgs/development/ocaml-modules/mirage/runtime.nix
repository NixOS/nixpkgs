{ lib, buildDunePackage, fetchurl, ipaddr, functoria-runtime
, fmt, logs, ocaml_lwt, alcotest }:

buildDunePackage rec {
  pname = "mirage-runtime";
  version = "3.9.0";

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/mirage/releases/download/v${version}/mirage-v${version}.tbz";
    sha256 = "1hznh49v1jlkwww6xi9f2f4yjzlh9qfvdrrdzvddnwsh3g00flla";
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
