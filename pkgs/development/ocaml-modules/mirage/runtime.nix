{ lib, buildDunePackage, fetchurl, ipaddr, functoria-runtime
, fmt, logs, ocaml_lwt, alcotest }:

buildDunePackage rec {
  pname = "mirage-runtime";
  version = "3.10.4";

  useDune2 = true;

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/mirage/releases/download/v${version}/mirage-v${version}.tbz";
    sha256 = "c2ea22b6faf16bed783cac0e0bafd87f321756a91798f56c9a930f0edb5d9116";
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
