{
  lib,
  buildDunePackage,
  fetchurl,
  fetchpatch,
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

  patches = lib.optional (lib.versionAtLeast lwt.version "6.0.0") (fetchpatch {
    url = "https://github.com/ocaml-multicore/lwt_eio/commit/5f8bf1e7af33590683ee45151894d7b9a20607f0.patch";
    hash = "sha256-5A3Bh+xOXo79Rw145hYqYv42li30M0TKLW+qu/dC0KQ=";
  });

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
