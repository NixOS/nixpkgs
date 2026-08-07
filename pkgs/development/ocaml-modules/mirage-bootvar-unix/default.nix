{
  lib,
  fetchurl,
  buildDunePackage,
  lwt,
  parse-argv,
}:

buildDunePackage (finalAttrs: {
  pname = "mirage-bootvar-unix";
  version = "0.1.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-bootvar-unix/releases/download/${finalAttrs.version}/mirage-bootvar-unix-${finalAttrs.version}.tbz";
    hash = "sha256-buVLmVBElmoZELZHDXAMxUUSIwT3KDBGZOB1e7zRImU=";
  };

  propagatedBuildInputs = [
    lwt
    parse-argv
  ];

  meta = {
    description = "Unix implementation of MirageOS Bootvar interface";
    homepage = "https://github.com/mirage/mirage-bootvar-unix";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
