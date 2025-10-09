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
  version = "4.10.1";
  src = fetchurl {
    url = "https://github.com/mirage/mirage/releases/download/v${finalAttrs.version}/mirage-${finalAttrs.version}.tbz";
    hash = "sha256:1155b5e9a585d3b44dfdd72777d94a7222b0f88a1737593bfb1f09954b6fb914";
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

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage";
    description = "Base MirageOS runtime library, part of every MirageOS unikernel";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
})
