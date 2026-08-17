{
  lib,
  buildDunePackage,
  fetchurl,
  eio,
  lwt,
}:
buildDunePackage (finalAttrs: {
  pname = "lwt_eio";
  version = if lib.versionAtLeast lwt.version "6.0.0" then "0.6" else "0.5.1";

  minimalOCamlVersion = "5.1";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/lwt_eio/releases/download/v${finalAttrs.version}/lwt_eio-${finalAttrs.version}.tbz";
    hash =
      {
        "0.5.1" = "sha256-dlJnhHh4VNO60NZJZqc1HS8wPR95WhdeBJTK37pPbCE=";
        "0.6" = "sha256-6xyIQyMRUE5Q+FQCzAkvaXZqqo8LSFzG6U1A7GZwSLw=";
      }
      ."${finalAttrs.version}";
  };

  propagatedBuildInputs = [
    eio
    lwt
  ];

  meta = {
    homepage = "https://github.com/ocaml-multicore/lwt_eio";
    changelog = "https://github.com/ocaml-multicore/lwt_eio/raw/v${finalAttrs.version}/CHANGES.md";
    description = "Use Lwt libraries from within Eio";
    license = with lib.licenses; [ isc ];
  };
})
