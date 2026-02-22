{
  lib,
  fetchurl,
  buildDunePackage,
  cmdliner,
  ipaddr,
  logs,
  lwt,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "mirage-runtime";
  version = "4.10.4";
  src = fetchurl {
    url = "https://github.com/mirage/mirage/releases/download/v${finalAttrs.version}/mirage-${finalAttrs.version}.tbz";
    hash = "sha256:sha256-9esFmDVST+Fl9IfRXXkMM8VrL83Qj6R1zUHlsFH5tH4=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    cmdliner
    ipaddr
    logs
    lwt
  ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/mirage/mirage";
    description = "Base MirageOS runtime library, part of every MirageOS unikernel";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
})
