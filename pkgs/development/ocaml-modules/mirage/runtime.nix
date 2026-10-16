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
  version = "4.11.2";
  src = fetchurl {
    url = "https://github.com/mirage/mirage/releases/download/v${finalAttrs.version}/mirage-${finalAttrs.version}.tbz";
    hash = "sha256:sha256-LL15JPgtha2O1rqy+NyV5r0VpyNTIZO1avAYE6sgsac=";
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
