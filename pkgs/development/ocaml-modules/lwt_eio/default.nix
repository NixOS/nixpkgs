{
  lib,
  buildDunePackage,
  fetchurl,
  eio,
  lwt,
}:
buildDunePackage rec {
  pname = "lwt_eio";
  version = "0.5.1";

  minimalOCamlVersion = "5.1";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-dlJnhHh4VNO60NZJZqc1HS8wPR95WhdeBJTK37pPbCE=";
  };

  propagatedBuildInputs = [
    eio
    lwt
  ];

  meta = {
    homepage = "https://github.com/ocaml-multicore/${pname}";
    changelog = "https://github.com/ocaml-multicore/${pname}/raw/v${version}/CHANGES.md";
    description = "Use Lwt libraries from within Eio";
    license = with lib.licenses; [ isc ];
  };
}
