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
  version = "4.10.2";
  src = fetchurl {
    url = "https://github.com/mirage/mirage/releases/download/v${finalAttrs.version}/mirage-${finalAttrs.version}.tbz";
    hash = "sha256-QYTLx+UbDc3PQ0XJiBjDQSn/Qoee8JHlSEn6pXsp05c=";
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
